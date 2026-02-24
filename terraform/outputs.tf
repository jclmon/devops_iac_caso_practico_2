output "resource_group_name" {
	description = "Resource group created for the VM deployment."
	value       = azurerm_resource_group.rg.name
}

output "vm_name" {
	description = "Linux virtual machine name."
	value       = azurerm_linux_virtual_machine.vm.name
}

output "public_ip_address" {
	description = "Public IP for SSH access."
	value       = azurerm_public_ip.pip.ip_address
}

output "ssh_command" {
	description = "SSH command to connect to the VM."
	value       = "ssh ${var.admin_username}@${azurerm_public_ip.pip.ip_address}"
}

output "acr_login_server" {
	description = "The login server of the Azure Container Registry (publicly accessible)."
	value       = azurerm_container_registry.acr.login_server
}

output "acr_name" {
	description = "The name of the Azure Container Registry."
	value       = azurerm_container_registry.acr.name
}

output "acr_id" {
	description = "The resource ID of the Azure Container Registry."
	value       = azurerm_container_registry.acr.id
}

output "acr_admin_username" {
	description = "Admin username for the ACR (use with caution)."
	value       = azurerm_container_registry.acr.admin_username
	sensitive   = true
}

output "acr_admin_password" {
	description = "Admin password for the ACR (use with caution)."
	value       = azurerm_container_registry.acr.admin_password
	sensitive   = true
}

output "aks_cluster_name" {
	description = "Name of the AKS cluster."
	value       = azurerm_kubernetes_cluster.aks.name
}

output "aks_cluster_id" {
	description = "AKS cluster resource ID."
	value       = azurerm_kubernetes_cluster.aks.id
}

output "aks_kubeconfig_command" {
	description = "Command to get kubeconfig for the AKS cluster."
	value       = "az aks get-credentials --resource-group ${azurerm_resource_group.rg.name} --name ${azurerm_kubernetes_cluster.aks.name}"
}

