# vpc


This module contains Terraform code to create an AWS networking setup based around a VPC

It uses [terraform-aws-vpc](https://github.com/terraform-aws-modules/terraform-aws-vpc/).

## Terraform Docs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.2.6 |
| aws | ~> 4.21.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.22 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_label"></a> [label](#module\_label) | https://github.com/cloudposse/terraform-null-label.git | v0.25.0 |

## Outputs

| Name | Description |
|------|-------------|
| context | all outputs emitted by module.eks |