
variable "resource_group_name" {
  description = "the name for the verdant project production resource group"
  type        = string
  default     = "verdant-prod"
}

variable "prod_cluster_name" {
  description = "name of the production cluster for the verdant project"
  type        = string
  default     = "verdant-prod"
}

variable "prod_vnet" {
  description = "name for the production vnet carrying the aks cluster"
  type        = string
  default     = "verdant-vnet-prod"
}

variable "verdant_location" {
  description = "region of verdant project resources"
  type        = string
  default     = "francecentral"
}
