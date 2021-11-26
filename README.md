# terraform-moder-data-platform:

Modern Data Platform environment created using terraform

![mdp-release1-details](mdp-release1-details.jpeg)

## Intro

This release of the terraform-modern-data-platform provides a basic Azure Databricks instance and three Azure v2 Storage Accounts to serve as the Bronze, Silver, Gold storage model popular in the Data Lake House model.  The ADB instance is secured in this release by removing the public IP address requiring all traffic to go through the Loadbalancer and no direct external traffic allowed.  We have also implemented the first of many Azure Policies, restricting the geopolitical location of the Databricks instance to East US 2 and Central US.

## Contents

- [Intro](#intro)
- [Requirements](#requirements)
- [1 - Resource Group](#1-core-resource-group)
- [Executing the Terraform](#executing-the-terraform)


## Requirements

- An Azure Subscription
- Terraform


## 1 Core Resource Group



## Executing the Terraform

### Initial Setup 
(once per environment) 

```{r, engine='sh', count_lines}
az account login
./ConfigureAzureForSecureTerraformAccess.sh
```

### Bootstrapping - from example directory
(per project/environment switch)

```
source ../TerraformAzureBootstrap.sh -f dev/dev.tfvars
terraform apply -var-file dev/dev.tfvars
```

### Example 1
source ../terraform-azure-bootstrap/TerraformAzureBootstrap.sh -f env/dev.tfvars
terraform apply --var-file env/dev.tfvars
