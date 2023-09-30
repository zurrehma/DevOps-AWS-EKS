provider "aws" {
  region                 = var.aws_region
  skip_region_validation = var.skip_region_validation
}


terraform {
  required_providers {
    aws = {
      version = "~> 4.21.0"
    }
  }
  required_version = "~> 1.4.6"
}