terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
}

data "tls_certificate" "oidc" {
  url = var.oidc_issuer_url
}

locals {
  oidc_issuer_hostpath = replace(var.oidc_issuer_url, "https://", "")
  external_secrets_sub = "system:serviceaccount:${var.external_secrets_namespace}:${var.external_secrets_service_account_name}"
  external_secrets_role_name = coalesce(
    var.external_secrets_role_name,
    "${var.cluster_name}-external-secrets-role"
  )
}

resource "aws_iam_openid_connect_provider" "eks" {
  url             = var.oidc_issuer_url
  client_id_list  = [var.oidc_audience]
  thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint]

  tags = var.tags
}

data "aws_iam_policy_document" "external_secrets_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_issuer_hostpath}:aud"
      values   = [var.oidc_audience]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_issuer_hostpath}:sub"
      values   = [local.external_secrets_sub]
    }
  }
}

resource "aws_iam_role" "external_secrets" {
  name               = local.external_secrets_role_name
  assume_role_policy = data.aws_iam_policy_document.external_secrets_assume_role.json
  tags               = var.tags
}

data "aws_iam_policy_document" "external_secrets_permissions" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParameterHistory",
      "ssm:DescribeParameters"
    ]
    resources = var.external_secrets_policy_resources
  }
}

resource "aws_iam_policy" "external_secrets" {
  count = var.create_external_secrets_policy ? 1 : 0

  name        = var.external_secrets_policy_name
  description = var.external_secrets_policy_description
  policy      = data.aws_iam_policy_document.external_secrets_permissions.json
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "external_secrets_managed_policy" {
  count = var.create_external_secrets_policy ? 1 : 0

  role       = aws_iam_role.external_secrets.name
  policy_arn = aws_iam_policy.external_secrets[0].arn
}

resource "aws_iam_role_policy_attachment" "external_secrets_additional" {
  for_each = toset(var.external_secrets_policy_arns)

  role       = aws_iam_role.external_secrets.name
  policy_arn = each.value
}
