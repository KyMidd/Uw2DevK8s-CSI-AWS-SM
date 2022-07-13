terraform {
  required_version = "~> 1.2"

  required_providers {
    aws = {
      version = "~> 4.22.0"
      source  = "hashicorp/aws"
    }
  }
}

# AWS provider
provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      Owner = "Kyler"
    }
  }
}

/*
# k8s provider
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
*/