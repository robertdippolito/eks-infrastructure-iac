terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = var.backend_bucket
    key            = var.backend_bucket_key
    region         = var.aws_region
    dynamodb_table = var.dynamodb_table
    encrypt        = true
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.7.1"
  namespace        = "ingress-nginx"
  create_namespace = true

  values = [
    <<EOF
controller:
  service:
    type: LoadBalancer
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-type: nlb
      service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
      service.beta.kubernetes.io/aws-load-balancer-name: ingress-nginx-${var.environment}
EOF
  ]
  force_update = true
}

module "ecr" {
  source = "./modules/ecr"

  namespace   = "api"
  repo_name   = var.repo_name
  environment = var.environment
}

module "vpc" {
  source      = "./modules/vpc"
  vpc_cidr    = var.vpc_cidr
  azs         = var.availability_zones
  environment = var.environment
}

module "eks_cluster" {
  source = "./modules/eks"

  cluster_name            = var.cluster_name
  cluster_role_arn        = module.iam.cluster_role_arn
  subnet_ids              = module.vpc.private_subnet_ids
  endpoint_public_access  = true
  endpoint_private_access = false
  kubernetes_version      = "1.31"
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

module "eks_managed_nodes" {
  source = "./modules/eks_managed_nodes"

  cluster_name           = module.eks_cluster.cluster_name
  node_group_name        = var.node_group_name
  node_role_arn          = module.iam.worker_role_arn
  subnet_ids             = module.vpc.private_subnet_ids
  desired_size           = 2
  min_size               = 1
  max_size               = 3
  instance_types         = ["t2.medium"]
  disk_size              = 20
  ami_type               = "AL2_x86_64"
  ec2_ssh_key            = var.ec2_ssh_key
  source_security_groups = [module.security_groups.sg_id]
  max_unavailable        = 1
  extra_tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks_cluster.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_cluster.cluster_name
}

data "aws_lb" "ingress_nginx" {
  tags = {
    "kubernetes.io/service-name" = "ingress-nginx/ingress-nginx-controller"
  }
  depends_on = [helm_release.ingress_nginx]
}

module "security_groups" {
  source       = "./modules/security_groups"
  cluster_name = module.eks_cluster.cluster_name
  vpc_id       = module.vpc.vpc_id
}

module "iam" {
  source       = "./modules/iam"
  cluster_name = module.eks_cluster.cluster_name
}

module "cloudfront" {
  source                 = "./modules/cf"
  nlb_dns_name           = data.aws_lb.ingress_nginx.dns_name
  origin_http_port       = 80
  origin_https_port      = 443
  origin_protocol_policy = "http-only"
  origin_ssl_protocols   = ["TLSv1.2"]

  comment     = "CF Distribution for API via NLB"
  price_class = "PriceClass_All"
  aliases     = var.aliases

  default_root_object = ""

  viewer_protocol_policy = "redirect-to-https"
  allowed_methods        = ["GET", "HEAD", "OPTIONS","POST", "PUT", "PATCH", "DELETE"]
  cached_methods         = ["GET", "HEAD", "OPTIONS"]
  forward_query_string   = false
  cookie_forwarding      = "none"
  min_ttl                = 0
  default_ttl            = 3600
  max_ttl                = 86400

  geo_restriction_type = "none"
  geo_locations        = []

  acm_certificate_arn      = module.route53_api_record.acm_certificate_arn
  ssl_support_method       = "sni-only"
  minimum_protocol_version = "TLSv1.2_2019"

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
  depends_on = [
    module.route53_api_record.acm_certificate_validation
  ]
}

module "route53_api_record" {
  source = "./modules/route53"

  zone_name                 = var.zone_name
  zone_comment              = var.zone_comment
  domain_name               = var.domain_name
  cloudfront_domain         = module.cloudfront.cloudfront_distribution_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.cloudfront_hosted_zone_id
  acm_certificate_validation = [
    for dvo in module.route53_api_record.acm_certificate.domain_validation_options : {
      fqdn = dvo.domain_name
    }
  ]
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

