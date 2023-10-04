provider "aws" {
  region                 = var.aws_region
  skip_region_validation = var.skip_region_validation
}


terraform {
  required_providers {
    aws = {
      version = ">= 4.57.0"
    }
  }
  required_version = "1.5.7"
}