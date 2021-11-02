# Configure the Azure provider
terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.80.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.1.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">=2.1.0"
    }
  }

  required_version = ">= 1.0.5"
}


