# Deployment of EKS
This repository contains files to create resources required to create AWS EKS.

## PreRequisits
Following tools need to be installed.
| Name | Version |
|------|---------|
| terraform | >= 1.2.6 |
| terragrunt | v0.38.0 |

To install the above requirements, the following command can be executed on Debian systems  
***Terraform***
```
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash
```

***Terragrunt***
```
curl -L https://raw.githubusercontent.com/warrensbox/tgswitch/release/install.sh | bash
tgswitch 0.38.0
```
The code is divided into modules and follows the best practices. Terragrunt helps in making the setup DRY(Don't Repeat Yourself).
## Directory Structure
#### modules
The modules directory contains all terraform modules.
| Module | Description |
|------|-------------|
| vpc | This module create AWS vpc |
| eks | This module create AWS EKS cluster |

#### demo
The demo directory contains the terragrunt files which will be used to create the whole setup.
| Directory | Description |
|------|-------------|
| vpc | contains terragrunt file to create vpc resources |
| eks | contains terragrunt file to create eks resources |

#### Recommendations
* The cluster autoscaler or karpenter can be used to scale workers on load.
* The monitoring can be improved by adding observability tools such as Prometheus for metrics and ELK for logs
* The authentication can be integrated with IAM using IAM authenticator and using aws-auth configmap on EKS side.
* The Kubernetes Service account permission to AWS services can be limited by using OIDC Provided URL by EKS with IAM.

#### Deployment Commands:
The demo directory will be used to deploy the whole setup.
For cloud resources, Terraform module [terraform-null-label](https://github.com/terraform-aws-modules/terraform-aws-eks/) is used to generate consistent names and tags for the resources. 
* Use ***demo/account.yaml*** to create consistent names. 
* Use ***demo/common_vars.yaml*** to update different module variables according to each environment.

Once tools are installed. Use ***aws configure*** to set up your connectivity with AWS cloud.
By default, resources are created inside ***us-east-1*** region. It can be updated inside ***demo/terragrunt.hcl*** file.
The state file is stored on s3 bucket.  
To initialize the backend first, use the below command in the demo root directory.
```
cd demo
terragrunt init
```
***To deploy VPC:***  
```
cd demo/vpc
terragrunt apply
```
***To deploy EKS Cluster:***  
```
cd demo/eks
terragrunt apply
```
***To connect with EKS cluster:***  
Use the below command to access eks cluster.
```
aws eks update-kubeconfig --region us-east-1 --name eks-cluster
```