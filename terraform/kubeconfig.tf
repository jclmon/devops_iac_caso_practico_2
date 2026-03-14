# Generate and write kubeconfig file
# This allows Ansible to connect to the cluster without running 'az aks get-credentials' manually

locals {
  kubeconfig_directory = pathexpand("~/.kube")
  kubeconfig_path      = "${local.kubeconfig_directory}/config"
}

# Generate kubeconfig and write to ~/.kube/config
# local_file automatically creates parent directories
resource "local_file" "kubeconfig" {
  filename              = local.kubeconfig_path
  content               = azurerm_kubernetes_cluster.aks.kube_config_raw
  file_permission       = "0600"
  directory_permission  = "0700"

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

# Output the kubeconfig content (sensitive)
output "kubeconfig_content" {
  description = "The raw kubeconfig content (sensitive - contains credentials)."
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

# Output kubeconfig location for Ansible
output "kubeconfig_location" {
  description = "Location where kubeconfig is written."
  value       = local_file.kubeconfig.filename
  depends_on = [
    local_file.kubeconfig
  ]
}
