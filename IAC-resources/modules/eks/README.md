# EKS

This module contains Terraform code to create an AWS EKS cluster

It uses [terraform-aws-eks](https://github.com/terraform-aws-modules/terraform-aws-eks/)

## Terraform Docs

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.2.6 |
| aws | ~> 4.21.0 |
| kubernetes | ~> 2.12.1 |

## Outputs

| Name | Description |
|------|-------------|
| context | all outputs emitted by module.eks |