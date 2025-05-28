
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
        max_count      = 3
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

resource "kubernetes_namespace" "ingress" {
    metadata {
      name = var.ingress_namespace
    }
}

resource "azurerm_public_ip" "verdant-public-ip" {
    name                = var.aks_public_ip_name
    resource_group_name = azurerm_kubernetes_cluster.verdant.node_resource_group
    location            = azurerm_kubernetes_cluster.verdant.location
    allocation_method   = "Static"
    domain_name_label = var.prod_cluster_name
    sku = "Standard"

    tags = {
        environment = "Production"
    }
}

resource "azurerm_role_assignment" "verdant-identity-ip-access" {
    principal_id = azurerm_kubernetes_cluster.verdant.identity[0].principal_id
    scope = azurerm_kubernetes_cluster.verdant.node_resource_group_id
    role_definition_name = "Network Contributor"
}

resource "helm_release" "ingress_controller" {
    name = "external"

    repository       = "https://kubernetes.github.io/ingress-nginx"
    chart            = "ingress-nginx"
    namespace        = var.ingress_namespace
    version          = "4.8.0"

    values = [
        yamlencode({
            controller = {
                ingressClassResource = {
                    name = "external-nginx"
                }
                service = {
                    annotations = {
                        "service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path" = "/healthz"
                        "service.beta.kubernetes.io/azure-dns-label-name" = var.prod_cluster_name
                    }
                    loadBalancerIP = azurerm_public_ip.verdant-public-ip.ip_address
                }
                watchIngressWithoutClass = true
                extraArgs = {
                    "ingress-class" = "external-nginx"
                }
            }
        })
    ]

    depends_on = [ azurerm_public_ip.verdant-public-ip ]
}

#
# resource "kubernetes_service" "aks_load_balancer" {
#     metadata {
#         name      = var.loadbalancer_name
#         annotations = {
#             "service.beta.kubernetes.io/azure-load-balancer-resource-group" = azurerm_kubernetes_cluster.verdant.node_resource_group
#             "service.beta.kubernetes.io/azure-pip-name" = azurerm_public_ip.verdant-public-ip.name
#             "service.beta.kubernetes.io/azure-dns-label-name" = var.prod_cluster_name
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

output "cluster-fqdn" {
   value = azurerm_public_ip.verdant-public-ip.fqdn
   description = "the url to access the cluster"
}

output "cluster-ip" {
    value = azurerm_public_ip.verdant-public-ip.ip_address
    description = "The public IP address of the cluster"
}
