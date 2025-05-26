
terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "=4.30.0"
        }
        helm = {
            source  = "hashicorp/helm"
            version = "=3.0.0-pre2"
        }
        kubernetes = {
            source = "hashicorp/kubernetes"
            version = "2.37.1"
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

provider "helm" {
  kubernetes = {
    host                   = azurerm_kubernetes_cluster.verdant.kube_config[0].host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.verdant.kube_config[0].client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.verdant.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.verdant.kube_config[0].cluster_ca_certificate)
  }
}

provider "kubernetes" {
    host                   = azurerm_kubernetes_cluster.verdant.kube_config[0].host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.verdant.kube_config[0].client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.verdant.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.verdant.kube_config[0].cluster_ca_certificate)
}
