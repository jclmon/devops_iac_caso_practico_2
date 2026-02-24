locals {
	# Nombre del ACR: debe ser unico a nivel global, sin guiones, solo letras y numeros (5-50 chars)
	acr_name = "${lower(replace(local.name_prefix, "-", ""))}${var.acr_sufix}"	
}

resource "azurerm_container_registry" "acr" {
	name                = local.acr_name 
	resource_group_name = azurerm_resource_group.rg.name
	location            = azurerm_resource_group.rg.location
	sku                 = var.acr_sku
	admin_enabled       = var.acr_admin_enabled
	tags                = local.common_tags
}

