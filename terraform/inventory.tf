# Generate dynamic Ansible inventory from template
resource "local_file" "ansible_inventory" {
	filename = "${path.module}/../ansible/inventory"
	
	content = templatefile("${path.module}/../ansible/inventory.tmpl", {
		resource_group_name    = azurerm_resource_group.rg.name
		vm_name                = azurerm_linux_virtual_machine.vm.name
		vm_ip                  = azurerm_public_ip.pip.ip_address
		admin_user             = var.admin_username
		ssh_private_key_path   = local_file.ssh_private_key.filename
		acr_name               = azurerm_container_registry.acr.name
		acr_login_server       = azurerm_container_registry.acr.login_server
		acr_admin_username     = azurerm_container_registry.acr.admin_username
		acr_admin_password     = azurerm_container_registry.acr.admin_password
		aks_cluster_name       = azurerm_kubernetes_cluster.aks.name
		aks_cluster_id         = azurerm_kubernetes_cluster.aks.id
		container_image        = "${azurerm_container_registry.acr.login_server}/azure-vote-front:latest"
		redis_image            = "${azurerm_container_registry.acr.login_server}/redis:latest"
	})
	
	depends_on = [
		azurerm_linux_virtual_machine.vm,
		azurerm_public_ip.pip,
		azurerm_container_registry.acr,
		azurerm_kubernetes_cluster.aks,
		local_file.ssh_private_key
	]
}

# Copy SSH private key for Ansible use
resource "local_file" "ssh_private_key" {
	filename             = "${path.module}/../ansible/keys/id_rsa"
	content              = file(var.ssh_private_key_path)
	file_permission      = "0600"
	directory_permission = "0700"
	
	depends_on = []
}

output "inventory_file" {
	description = "Path to the generated Ansible inventory file."
	value       = local_file.ansible_inventory.filename
}

output "ssh_private_key_file" {
	description = "Path to the SSH private key copied for Ansible."
	value       = local_file.ssh_private_key.filename
}
