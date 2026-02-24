# Descripcion: Crea la red virtual donde se desplegara la maquina virtual.
resource "azurerm_virtual_network" "vnet" {
	name                = "${local.name_prefix}-vm-virtual-network"
	address_space       = var.address_space
	location            = azurerm_resource_group.rg.location
	resource_group_name = azurerm_resource_group.rg.name
	tags                = local.common_tags
}
