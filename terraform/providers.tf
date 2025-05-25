
terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "=4.30.0"
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
    subscription_id = "3c7b7f02-b137-4a45-baee-046d04864904"
}
