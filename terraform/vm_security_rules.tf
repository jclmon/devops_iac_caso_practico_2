# Descripcion: Permite acceso SSH al puerto 22 desde la red autorizada.
resource "azurerm_network_security_rule" "allow_ssh" {
	name                        = "${local.name_prefix}-allow-ssh"
	priority                    = 1000
	direction                   = "Inbound"
	access                      = "Allow"
	protocol                    = "Tcp"
	source_port_range           = "*"
	destination_port_range      = "22"
	source_address_prefix       = var.allowed_ssh_cidr
	destination_address_prefix  = "*"
	resource_group_name         = azurerm_resource_group.rg.name
	network_security_group_name = azurerm_network_security_group.nsg.name
}

# Descripcion: Permite trafico HTTP al puerto 80.
resource "azurerm_network_security_rule" "allow_http" {
  name                        = "${local.name_prefix}-allow-http"
  priority                    = 1010
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Descripcion: Permite trafico HTTPS al puerto 443.
resource "azurerm_network_security_rule" "allow_https" {
  name                        = "${local.name_prefix}-allow-https"
  priority                    = 1020
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}