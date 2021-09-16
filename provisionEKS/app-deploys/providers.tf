terraform {
  required_version = ">=0.15.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2"
    }
  }
  backend "s3" {
    region = var.region

  }
}

provider "aws" {
  region = "eu-west-2"
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.network.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode("${data.terraform_remote_state.network.outputs.cluster_auth}")
  token                  = data.terraform_remote_state.network.outputs.cluster_token
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.network.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode("${data.terraform_remote_state.network.outputs.cluster_auth}")
    token                  = data.terraform_remote_state.network.outputs.cluster_token
  }
}
