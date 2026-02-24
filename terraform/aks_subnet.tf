# Descripcion: Crea la subred dedicada para el cluster AKS.
resource "azurerm_subnet" "aks_subnet" {
	name                 = "${local.name_prefix}-aks-subnet"
	resource_group_name  = azurerm_resource_group.rg.name
	virtual_network_name = azurerm_virtual_network.vnet.name
	address_prefixes     = var.aks_subnet_prefix
}
