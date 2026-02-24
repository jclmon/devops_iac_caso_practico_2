# Descripcion: Crea el cluster AKS con una subred dedicada y asigna permisos para acceder al ACR.
resource "azurerm_kubernetes_cluster" "aks" {
	name                = "${local.name_prefix}-aks"
	location            = azurerm_resource_group.rg.location
	resource_group_name = azurerm_resource_group.rg.name
	dns_prefix          = "${local.name_prefix}-aks"
	sku_tier            = var.aks_sku_tier

	default_node_pool {
		name           = "default"
		node_count     = var.aks_node_count
		vm_size        = var.aks_vm_size
		vnet_subnet_id = azurerm_subnet.aks_subnet.id
	}

	identity {
		type = var.aks_identity_type
	}

	network_profile {
		network_plugin = "azure"
		service_cidr   = var.aks_service_cidr
		dns_service_ip = var.aks_dns_service_ip
	}

	tags = local.common_tags
}

# Descripcion: Asigna permisos AcrPull a la identidad del AKS para acceder al ACR.
resource "azurerm_role_assignment" "aks_acr_pull" {
	principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
	role_definition_name = "AcrPull"
	scope                = azurerm_container_registry.acr.id
}
