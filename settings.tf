terraform {
  backend "s3" {}
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = "~> 0.7"
    }
  }
}
