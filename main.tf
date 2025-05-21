terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "terraform-state-bucket-k8s-api"
    key            = "k8s-api-infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
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
  repo_name   = "my-repo"
  environment = "dev"
}

module "vpc" {
  source      = "./modules/vpc"
  vpc_cidr    = "10.0.0.0/16"
  azs         = ["us-east-1a", "us-east-1b", "us-east-1c"]
  environment = var.environment
}

module "eks_cluster" {
  source = "./modules/eks"

  cluster_name            = "my-eks-cluster"
  cluster_role_arn        = module.iam.cluster_role_arn
  subnet_ids              = module.vpc.private_subnet_ids
  endpoint_public_access  = true
  endpoint_private_access = false
  kubernetes_version      = "1.31"
  tags = {
    Environment = "dev"
    Project     = "my-eks-cluster"
  }
}

module "eks_managed_nodes" {
  source = "./modules/eks_managed_nodes"

  cluster_name           = module.eks_cluster.cluster_name
  node_group_name        = "my-eks-managed-nodes"
  node_role_arn          = module.iam.worker_role_arn
  subnet_ids             = module.vpc.private_subnet_ids
  desired_size           = 2
  min_size               = 1
  max_size               = 3
  instance_types         = ["t2.medium"]
  disk_size              = 20
  ami_type               = "AL2_x86_64"
  ec2_ssh_key            = "k8s-kvp"
  source_security_groups = [module.security_groups.sg_id]
  max_unavailable        = 1
  extra_tags = {
    Environment = "prod"
    Project     = "my-eks-cluster"
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks_cluster.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_cluster.cluster_name
}

data "aws_lb" "ingress_nginx" {
  # pick the one LB whose service tag matches your Helm release
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
  aliases     = ["api.anytimeagile.com"]

  default_root_object = ""

  viewer_protocol_policy = "redirect-to-https"
  allowed_methods        = ["GET", "HEAD", "OPTIONS"]
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
    Environment = "dev"
    Project     = "my-api"
  }
  depends_on = [
    module.route53_api_record.acm_certificate_validation
  ]
}

module "route53_api_record" {
  source = "./modules/route53"

  zone_name                 = "anytimeagile.com" # The apex domain for the hosted zone
  zone_comment              = "Hosted zone for anytimeagile.com"
  domain_name               = "api.anytimeagile.com" # The FQDN to direct traffic to CloudFront
  cloudfront_domain         = module.cloudfront.cloudfront_distribution_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.cloudfront_hosted_zone_id
  acm_certificate_validation = [
    for dvo in module.route53_api_record.acm_certificate.domain_validation_options : {
      fqdn = dvo.domain_name
    }
  ]
  tags = {
    Environment = "dev"
    Project     = "api-routing"
  }
}

