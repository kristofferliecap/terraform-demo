# Root resouce group
resource "azurerm_resource_group" "root" {
  name     = "root"
  location = "West Europe"
  tags = {
    app       = "Demo"
    managedBy = "Terraform"
  }
}

## Networking ##
### Virtual Network ###
resource "azurerm_virtual_network" "demo-vnet" {
  name                = "demo-vnet"
  location            = azurerm_resource_group.root.location
  resource_group_name = azurerm_resource_group.root.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    app       = "Demo"
    managedBy = "Terraform"
  }
}

# Create a subnet for the Web App and Key Vault
resource "azurerm_subnet" "demo-subnet" {
  name                 = "demo-subnet"
  resource_group_name  = azurerm_resource_group.root.name
  virtual_network_name = azurerm_virtual_network.demo-vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  # Add service endpoint for Key Vault
  service_endpoints = ["Microsoft.KeyVault", "Microsoft.Web"]
}


### Web app ### 
resource "azurerm_service_plan" "demo-asp" {
  name                = "demo-asp"
  resource_group_name = azurerm_resource_group.root.name
  location            = azurerm_resource_group.root.location
  os_type             = "Linux"
  sku_name            = "B1"
  tags = {
    app       = "Demo"
    managedBy = "Terraform"
  }
}

resource "azurerm_linux_web_app" "demo-app" {
  name                = "demo-terraform-app"
  resource_group_name = azurerm_resource_group.root.name
  location            = azurerm_resource_group.root.location
  service_plan_id     = azurerm_service_plan.demo-asp.id



  identity {
    type = "SystemAssigned" ## Added managed identity
  }

  site_config {
    ip_restriction {
      virtual_network_subnet_id = azurerm_subnet.demo-subnet.id
    }
    application_stack {
      dotnet_version = "8.0"
    }
  }

}

## Key Vault ## 
resource "azurerm_key_vault" "demo-kv" {
  name                       = "demoappkeyvault2024"
  location                   = azurerm_resource_group.root.location
  resource_group_name        = azurerm_resource_group.root.name
  tenant_id                  = ""
  soft_delete_retention_days = 7

  sku_name = "standard"

  enable_rbac_authorization = true
  network_acls {
    default_action             = "Allow"
    virtual_network_subnet_ids = [azurerm_subnet.demo-subnet.id]
    bypass                     = "None"
  }
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_key_vault_secret" "password" {
  name         = "secret-sauce"
  value        = random_password.password.result #
  key_vault_id = azurerm_key_vault.demo-kv.id
}

## RBAC ##
## Give the web app accsess to key vault
resource "azurerm_role_assignment" "kv_secret_user" {
  scope                = azurerm_key_vault.demo-kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_web_app.demo-app.identity[0].principal_id
}


