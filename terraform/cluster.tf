
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

resource "helm_release" "ingress_controller" {
    name = "external"

    repository       = "https://kubernetes.github.io/ingress-nginx"
    chart            = "ingress-nginx"
    namespace        = var.ingress_namespace
    version          = "4.8.0"

    values = [file("${path.module}/values/ingress.yaml")]
}

resource "kubernetes_namespace" "ingress" {
    metadata {
      name = var.ingress_namespace
    }
}

# resource "kubernetes_service" "aks_load_balancer" {
#     metadata {
#         name      = var.loadbalancer_name
#         namespace = helm_release.ingress_controller.namespace
#         annotations = {
#             "service.beta.kubernetes.io/azure-load-balancer-resource-group" = var.resource_group_name
#         }
#     }
#
#     spec {
#         selector = {
#             name = "verdant-ingress"
#         }
#
#         port {
#             protocol    = "TCP"
#             port        = 80
#             target_port = 80
#         }
#
#         type = "LoadBalancer"
#
#     }
# }
