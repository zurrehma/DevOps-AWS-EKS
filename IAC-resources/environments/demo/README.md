# Deploy EKS Infra

### Deploy New Environment (Using Terraform)
##### Step 1:
Create a new Branch from master 

##### Step 2: 
Update Github default workflow yaml file and update branch name and that yaml file exist in 
``` yaml
.github/workflows/default.yaml
```
and changes are :
``` yaml
on:
  push:
    branches:
      - Branch Name
```

##### Step 3:
Make following changes in Account.yaml that are as follow:


``` yaml
- cidr_b_block : 132
- namespace : demo
- environment : uat
- repo_branch: "dev"
- aws-users:
        - { name: "eks-test", arn: "arn:aws:iam::806240344948:user/eks-test", groups: ["k8s-dev"] } 
```
- cidr_b_block: 
    - this variable make VPC Unique then others 
- namespace:
    - terraform resources prefix
- environment:
    - name of the environment that will create.
-  repo_branch: 
    - Github repo branch name that resouces deploy in EKS Cluster 
-  aws-users: 
    - if you want to add USers permisions to EKS Cluster Resources then define that user like above example

##### Note: 
- we can add users only two groups for readonly you can add user in "k8s-dev" group and for admin users you can add in "system:masters" Group.
 
##### Step 4:
Update Local variable in Terragrunt.hcl file 
``` hcl
locals {
  environment = "uat"
  aws_region = "us-east-1"
}
```

Step 5: 
Update VPC Cidr in Network Load Balancer file named as "nlb.yaml" that exit in 
``` yaml
k8-resources/cluster-addons/ingress/nlb.yaml
```
and changes are:
``` yaml 
proxy-real-ip-cidr: 10.132.0.0/16
```
