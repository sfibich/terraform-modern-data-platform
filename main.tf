locals {
  main_tags        = merge(var.tags, var.env_tags)
  allowed_list_ips = split(",", coalesce(var.allowed_list_ips, chomp(data.http.icanhazip.body)))
  default_name     = "${var.prefix}-${var.company_name}-${random_string.suffix.result}"
  raw_storage_name = "${lower(var.prefix)}raw${lower(var.company_name)}${random_string.suffix.result}"
}


module "azure_policies" {
  source            = "./modules/azure_policies"
  resource_group_id = azurerm_resource_group.mdp.id
}

resource "random_pet" "server" {
}

resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}


resource "azurerm_resource_group" "mdp" {
  name     = "dbw-${local.default_name}"
  location = "East US2"
  tags     = local.main_tags
}


resource "azurerm_virtual_network" "mdp" {
  name                = "${var.prefix}-databricks-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.mdp.location
  resource_group_name = azurerm_resource_group.mdp.name

  tags = local.main_tags

}

resource "azurerm_subnet" "public" {
  name                 = "${var.prefix}-public-subnet"
  resource_group_name  = azurerm_resource_group.mdp.name
  virtual_network_name = azurerm_virtual_network.mdp.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "${var.prefix}-databricks-del"

    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
      ]
      name = "Microsoft.Databricks/workspaces"
    }
  }
}

resource "azurerm_subnet" "private" {
  name                 = "${var.prefix}-private-subnet"
  resource_group_name  = azurerm_resource_group.mdp.name
  virtual_network_name = azurerm_virtual_network.mdp.name
  address_prefixes     = ["10.0.2.0/24"]

  delegation {
    name = "${var.prefix}-databricks-del"

    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
      ]
      name = "Microsoft.Databricks/workspaces"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.mdp_adb.id
}

resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.mdp_adb.id
}

resource "azurerm_network_security_group" "mdp_adb" {
  name                = "${var.prefix}-databricks-nsg"
  location            = azurerm_resource_group.mdp.location
  resource_group_name = azurerm_resource_group.mdp.name
}

resource "azurerm_databricks_workspace" "mdp_adb" {
  name                        = "dbw-${local.default_name}"
  resource_group_name         = azurerm_resource_group.mdp.name
  location                    = azurerm_resource_group.mdp.location
  sku                         = "premium"
  managed_resource_group_name = "dbw-managed-${local.default_name}"

  public_network_access_enabled         = true
  load_balancer_backend_address_pool_id = azurerm_lb_backend_address_pool.mdp_adb.id

  custom_parameters {
    no_public_ip        = true
    public_subnet_name  = azurerm_subnet.public.name
    private_subnet_name = azurerm_subnet.private.name
    virtual_network_id  = azurerm_virtual_network.mdp.id

    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public.id
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private.id
  }

  tags = local.main_tags

}

resource "azurerm_public_ip" "mdp_adb" {
  name                    = "databricks-lb-public-ip"
  location                = azurerm_resource_group.mdp.location
  resource_group_name     = azurerm_resource_group.mdp.name
  idle_timeout_in_minutes = 4
  allocation_method       = "Static"

  sku  = "Standard"
  tags = local.main_tags

}

resource "azurerm_lb" "mdp_adb" {
  name                = "databricks-lb"
  location            = azurerm_resource_group.mdp.location
  resource_group_name = azurerm_resource_group.mdp.name

  sku = "Standard"

  frontend_ip_configuration {
    name                 = "databricks-pip"
    public_ip_address_id = azurerm_public_ip.mdp_adb.id
  }
  tags = local.main_tags
}

resource "azurerm_lb_outbound_rule" "mdp_adb" {
  name                = "databricks-lb-outbound-rules"
  resource_group_name = azurerm_resource_group.mdp.name

  loadbalancer_id          = azurerm_lb.mdp_adb.id
  protocol                 = "All"
  enable_tcp_reset         = true
  allocated_outbound_ports = 1024
  idle_timeout_in_minutes  = 4

  backend_address_pool_id = azurerm_lb_backend_address_pool.mdp_adb.id

  frontend_ip_configuration {
    name = azurerm_lb.mdp_adb.frontend_ip_configuration.0.name
  }
}

resource "azurerm_lb_backend_address_pool" "mdp_adb" {
  loadbalancer_id = azurerm_lb.mdp_adb.id
  name            = "Databricks-BE"
}



# Create a default cluster named terraform-mount and mount the exmple container of the RAW Storage Container
data "azurerm_databricks_workspace" "this" {
  name                = azurerm_databricks_workspace.mdp_adb.name
  resource_group_name = azurerm_resource_group.mdp.name
  depends_on          = [azurerm_databricks_workspace.mdp_adb]
}

provider "databricks" {
  host = data.azurerm_databricks_workspace.this.workspace_url
}

resource "databricks_secret_scope" "terraform" {
  name                     = "application"
  initial_manage_principal = "users"
}

resource "databricks_secret" "storage_key" {
  key          = "blob_storage_key"
  string_value = azurerm_storage_account.raw.primary_access_key
  scope        = databricks_secret_scope.terraform.name
}

resource "databricks_mount" "raw" {
  name = "example"
  wasb {
    container_name       = azurerm_storage_container.raw_example.name
    storage_account_name = azurerm_storage_account.raw.name
    auth_type            = "ACCESS_KEY"
    token_secret_scope   = databricks_secret_scope.terraform.name
    token_secret_key     = databricks_secret.storage_key.key
  }
}

resource "databricks_mount" "haystak" {
  name = "haystack"
  wasb {
    container_name       = azurerm_storage_container.haystack.name
    storage_account_name = azurerm_storage_account.raw.name
    auth_type            = "ACCESS_KEY"
    token_secret_scope   = databricks_secret_scope.terraform.name
    token_secret_key     = databricks_secret.storage_key.key
  }
}


resource "databricks_notebook" "example" {
  content_base64 = filebase64("test.ipynb")
  path           = "/Shared/test/test.ipynb"
  language       = "PYTHON"
}

