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
  subscription_id = ""
  tenant_id       = ""
}

