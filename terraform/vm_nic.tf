# Descripcion: Crea la interfaz de red de la maquina virtual.
resource "azurerm_network_interface" "nic" {
	name                = "${local.name_prefix}-vm-network-interface"
	location            = azurerm_resource_group.rg.location
	resource_group_name = azurerm_resource_group.rg.name
	tags                = local.common_tags

	ip_configuration {
		name                          = "${local.name_prefix}-vm-network-interface-ipconfig"
		subnet_id                     = azurerm_subnet.subnet.id
		private_ip_address_allocation = "Dynamic"
		public_ip_address_id          = azurerm_public_ip.pip.id
	}
}

# Descripcion: Asocia la interfaz de red al grupo de seguridad.
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
	network_interface_id      = azurerm_network_interface.nic.id
	network_security_group_id = azurerm_network_security_group.nsg.id
}
