# Descripcion: Genera un sufijo aleatorio para evitar colisiones de nombres.
resource "random_string" "suffix" {
	length  = 4
	upper   = false
	numeric = true
	special = false
}

locals {
	name_prefix = "${var.name_prefix}-${var.environment}"
}

# Descripcion: Crea el grupo de recursos principal de la solucion.
resource "azurerm_resource_group" "rg" {
	name     = "${local.name_prefix}-rg"
	location = var.location
	tags     = local.common_tags
}
