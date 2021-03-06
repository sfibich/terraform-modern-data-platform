# terraform-moder-data-platform:

Modern Data Platform environment created using terraform

## Contents

- [Intro](#intro)
- [Detalis](#details)
- [Requirements](#requirements)
- [Executing the Terraform](#executing-the-terraform)

![mdp-release1-details](mdp-release1-details.jpeg)
## Intro

This release of the terraform-modern-data-platform provides a basic Azure Databricks instance and three Azure v2 Storage Accounts to serve as the Bronze, Silver, Gold storage model popular in the Data Lake House model.  The ADB instance is secured in this release by removing the public IP address requiring all traffic to go through the Loadbalancer and no direct external traffic allowed.  We have also implemented the first of many Azure Policies, restricting the geopolitical location of the Databricks instance to East US 2 and Central US.

## Details

1. Core Resource Group
2. Managed Resource Group (auto generated by Azure Databricks)
3. Vnet - in the Core Resource Group but affects resources in the managed resource group 
4. Public Subnet  
5. Private Subnet
6. NSG that protects both the public & private subnets
7. Loadbalancer that points to the Public Subnet
8. Public IP address for the Load Balancer
9. 3 v2 Storage Accounts for the Modern Data Platform
10. The Azure Databricks Service Instance
11. VMs spun up when a Databricks cluster is spun up
12. Azure Policy restricting the Regions to eastus2 & centralus

## Requirements

- An Azure Subscription
- Terraform

## Executing the Terraform

### Initial Setup 
(once per environment) 

```{r, engine='sh', count_lines}
az account login
./ConfigureAzureForSecureTerraformAccess.sh
```

### Bootstrapping & executing
(per project/environment switch)

```
source ../terraform-azure-bootstrap/TerraformAzureBootstrap.sh -f env/dev.tfvars
terraform apply -var-file env/dev.tfvars
```

### Executing after bootstrapping
```
terraform apply --var-file env/dev.tfvars
```
