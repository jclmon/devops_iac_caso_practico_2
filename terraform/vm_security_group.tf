# Descripcion: Crea el grupo de seguridad de red para controlar trafico de la VM.
resource "azurerm_network_security_group" "nsg" {
	name                = "${local.name_prefix}-vm-network-security-group"
	location            = azurerm_resource_group.rg.location
	resource_group_name = azurerm_resource_group.rg.name
	tags                = local.common_tags
}
