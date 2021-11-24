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
