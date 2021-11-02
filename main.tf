locals {
  main_tags        = merge(var.tags, var.env_tags)
  allowed_list_ips = split(",", coalesce(var.allowed_list_ips, chomp(data.http.icanhazip.body)))
}

resource "random_pet" "server" {
}

resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-${var.machine_number}-rg"
  location = var.location
  tags     = local.main_tags
}

resource "azurerm_resource_group" "managed" {
  name     = "${var.prefix}-mngd-${var.machine_number}-rg"
  location = var.location
  tags     = local.main_tags
}


resource "azurerm_databricks_workspace" "mdp" {
  name                = "${var.prefix}-adb-${var.machine_number}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "standard"

  managed_resource_group_name = azurerm_resource_group.managed.name

  #managed_services_cmk_key_vault_key_id

  #sku needs to be premium to set true values
  customer_managed_key_enabled      = false
  infrastructure_encryption_enabled = false



  tags = local.main_tags

}




