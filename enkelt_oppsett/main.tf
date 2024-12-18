# Root resouce group
resource "azurerm_resource_group" "root" {
  name     = "root"
  location = "West Europe"
  tags = {
    app       = "Demo"
    managedBy = "Terraform"
  }
}

### Web app ### 
resource "azurerm_service_plan" "demo-asp" {
  name                = "demo-asp"
  resource_group_name = azurerm_resource_group.root.name
  location            = azurerm_resource_group.root.location
  os_type             = "Linux"
  sku_name            = "B1"
  tags = {
    app       = "demo"
    managedBy = "Terraform"
  }
}

resource "azurerm_linux_web_app" "demo-app" {
  name                = "demo-terraform-app"
  resource_group_name = azurerm_resource_group.root.name
  location            = azurerm_resource_group.root.location
  service_plan_id     = azurerm_service_plan.demo-asp.id

  site_config {
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
}
