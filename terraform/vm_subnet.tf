# Descripcion: Crea la subred donde se conectara la interfaz de red de la VM.
resource "azurerm_subnet" "subnet" {
	name                 = "${local.name_prefix}-vm-subnet"
	resource_group_name  = azurerm_resource_group.rg.name
	virtual_network_name = azurerm_virtual_network.vnet.name
	address_prefixes     = var.subnet_prefixes
}
