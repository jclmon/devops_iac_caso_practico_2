# Descripcion: Crea la IP publica de la maquina virtual.
resource "azurerm_public_ip" "pip" {
	name                = "${local.name_prefix}-vm-public-ip"
	location            = azurerm_resource_group.rg.location
	resource_group_name = azurerm_resource_group.rg.name
	allocation_method   = var.public_ip_allocation_method
	sku                 = var.public_ip_sku    
    domain_name_label   = "${local.name_prefix}-vm-pip"
	tags                = local.common_tags
    idle_timeout_in_minutes = 30
}

# Descripcion: Consulta la IP publica creada para su uso en salidas o dependencias.
data "azurerm_public_ip" "pip" {
  name                = azurerm_public_ip.pip.name
  resource_group_name = azurerm_linux_virtual_machine.vm.resource_group_name
}