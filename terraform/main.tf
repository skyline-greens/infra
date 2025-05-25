
resource "azurerm_resource_group" "verdant-prod" {
    name     = var.resource_group_name
    location = var.verdant_location
}

resource "azurerm_virtual_network" "verdant-vnet" {
    resource_group_name = azurerm_resource_group.verdant-prod.name
    name                = var.prod_vnet
    address_space       = ["10.0.0.0/16"]
    location            = var.verdant_location

}

resource "azurerm_subnet" "verdant-prod-subnet" {
    name                 = "${var.prod_vnet}-cluster"
    resource_group_name  = azurerm_resource_group.verdant-prod.name
    address_prefixes     = ["10.0.1.0/24"]
    virtual_network_name = azurerm_virtual_network.verdant-vnet.name
}

resource "azurerm_kubernetes_cluster" "verdant" {
    resource_group_name = azurerm_resource_group.verdant-prod.name
    location            = var.verdant_location
    name                = var.prod_cluster_name
    dns_prefix          = "verdant-dns"
    kubernetes_version = "1.33"

    default_node_pool {
        name           = "verdant"
        vm_size        = "Standard_A2_v2"
        node_count = 1
        min_count      = 1
        max_count      = 2
        auto_scaling_enabled = true
    }

    identity {
        type = "SystemAssigned"
    }
    sku_tier = "Free"

    tags = {
        Environment = "production"
    }
}
