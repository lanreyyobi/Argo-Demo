terraform {
  required_providers {
    aws = {
     source  = "hashicorp/aws"
     version = "~> 5.0"
     }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

# Provider block
provider "aws" {
  region = ""
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.token
}

