terraform {
  backend "azurerm" {} ## added this to refer to global state file
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.1"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "f8375a9b-23ee-4c9e-bf74-0c028c03cc7d"
  tenant_id       = "e55fe2f3-baa4-4436-9c28-92e8383cd851"
}

