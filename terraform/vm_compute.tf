# Descripcion: Crea la maquina virtual Linux y configura acceso SSH por clave.
resource "azurerm_linux_virtual_machine" "vm" {
	name                            = "${local.name_prefix}-vm"
	resource_group_name             = azurerm_resource_group.rg.name
	location                        = azurerm_resource_group.rg.location
	size                            = var.vm_size
	admin_username                  = var.admin_username
	network_interface_ids           = [azurerm_network_interface.nic.id]
	disable_password_authentication = true
	tags                            = local.common_tags

	admin_ssh_key {
		username   = var.admin_username
		public_key = var.ssh_public_key
	}

	os_disk {
		caching              = var.vm_os_disk_caching
		storage_account_type = var.vm_os_disk_storage_account_type
	}

	source_image_reference {
		publisher = var.vm_image_publisher
		offer     = var.vm_image_offer
		sku       = var.vm_image_sku
		version   = var.vm_image_version
	}

	boot_diagnostics {}
}
