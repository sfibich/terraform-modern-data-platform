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

