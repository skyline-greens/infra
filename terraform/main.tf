
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
