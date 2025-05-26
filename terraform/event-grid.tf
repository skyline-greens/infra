
resource "azurerm_eventgrid_namespace" "mqtt-broker" {
    name = var.eventgrid_namespace
    location = var.verdant_location
    resource_group_name = azurerm_resource_group.verdant-prod.name

    tags = {
        Environment = "production"
    }
}
