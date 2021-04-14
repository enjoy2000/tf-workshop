terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.0"
    }
    kubernetes = {
      version = ">= 1.9"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
  shared_credentials_file = "~/.aws/credentials"
  profile = "tf-workshop"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}
