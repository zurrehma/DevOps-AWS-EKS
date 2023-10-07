terraform {
  required_providers {
    aws = {
      version = ">= 4.57.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
  required_version = "1.5.7"
}