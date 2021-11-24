resource "azurerm_storage_account" "raw" {
  name                     = "${lower(var.prefix)}raw${lower(var.company_name)}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.mdp.name
  location                 = azurerm_resource_group.mdp.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  is_hns_enabled           = true
  tags                     = local.main_tags
}


resource "azurerm_storage_container" "raw_example" {
  name                  = "example"
  storage_account_name  = azurerm_storage_account.raw.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "example" {
  name                   = "example.csv"
  storage_account_name   = azurerm_storage_account.raw.name
  storage_container_name = azurerm_storage_container.raw_example.name
  type                   = "Block"
  source                 = "example.csv"
}

resource "azurerm_storage_container" "raw_core" {
  name                  = "core"
  storage_account_name  = azurerm_storage_account.raw.name
  container_access_type = "private"
}


resource "azurerm_storage_account" "refined" {
  name                     = "${lower(var.prefix)}refined${lower(var.company_name)}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.mdp.name
  location                 = azurerm_resource_group.mdp.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  is_hns_enabled           = true
  tags                     = local.main_tags
}


resource "azurerm_storage_container" "refined_core" {
  name                  = "core"
  storage_account_name  = azurerm_storage_account.refined.name
  container_access_type = "private"
}

resource "azurerm_storage_account" "modeled" {
  name                     = "${lower(var.prefix)}modeled${lower(var.company_name)}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.mdp.name
  location                 = azurerm_resource_group.mdp.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  is_hns_enabled           = true
  tags                     = local.main_tags
}


resource "azurerm_storage_container" "modeled_core" {
  name                  = "core"
  storage_account_name  = azurerm_storage_account.modeled.name
  container_access_type = "private"
}


