
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  required_version = ">= 1.6"
  backend "azurerm" {
    resource_group_name  = "infra-management"
    use_azuread_auth     = true
    storage_account_name = "verdantmanagementsa"
    container_name       = "configuration"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
