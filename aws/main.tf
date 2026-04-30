terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50"
    }
  }
  required_version = ">= 1.6"
}

provider "aws" {
  region = var.region
}

resource "aws_iam_user" "capi" {
  name = "yage-capi-${var.cluster_name}"
  path = "/yage/"
  tags = {
    ManagedBy   = "yage-tofu"
    ClusterName = var.cluster_name
  }
}

resource "aws_iam_access_key" "capi" {
  user = aws_iam_user.capi.name
}

resource "aws_iam_user_policy_attachment" "capi" {
  user       = aws_iam_user.capi.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
