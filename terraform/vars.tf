variable "subscription_id" {
	description = "Id de la suscripcion de Azure donde se desplegaran los recursos."
	type        = string
}

variable "location" {
	description = "Region de Azure para el despliegue."
	type        = string
	default     = "westeurope"
}

variable "project" {
	description = "Valor del tag de proyecto."
	type        = string
	default     = "devops_iac_caso_practico_2"
}

variable "name_prefix" {
	description = "Prefijo base usado al inicio de los nombres de recursos de Azure."
	type        = string
	default     = "jclmon-iac"
}

variable "environment" {
	description = "Prefijo adicional para diferenciar environmnent."
	type        = string
	default     = "casopractico2"
}

variable "extra_tags" {
	description = "Tags adicionales para combinar con los tags comunes."
	type        = map(string)
	default     = {}
}

variable "admin_username" {
	description = "Usuario administrador para la VM Linux."
	type        = string
	default     = "azureuser"
}

variable "ssh_public_key" {
	description = "Contenido de la clave publica SSH para acceder a la VM."
	type        = string
	sensitive   = true
}

variable "vm_size" {
	description = "Tamano de la VM en Azure."
	type        = string
	default     = "Standard_B2s"
}

variable "vm_image_publisher" {
	description = "Publicador de la imagen de la VM."
	type        = string
	default     = "Canonical"
}

variable "vm_image_offer" {
	description = "Oferta de la imagen de la VM."
	type        = string
	default     = "0001-com-ubuntu-server-jammy"
}

variable "vm_image_sku" {
	description = "Sku de la imagen de la VM."
	type        = string
	default     = "22_04-lts"
}

variable "vm_image_version" {
	description = "Version de la imagen de la VM (usa un valor fijo para pin)."
	type        = string
	default     = "latest"
}

variable "vm_os_disk_caching" {
	description = "Tipo de cache para el disco del SO."
	type        = string
	default     = "ReadWrite"
}

variable "vm_os_disk_storage_account_type" {
	description = "Tipo de almacenamiento para el disco del SO."
	type        = string
	default     = "Standard_LRS"
}

variable "public_ip_allocation_method" {
	description = "Metodo de asignacion de la IP publica (Static o Dynamic)."
	type        = string
	default     = "Static"
}

variable "public_ip_sku" {
	description = "Sku de la IP publica (Standard o Basic)."
	type        = string
	default     = "Standard"
}

variable "address_space" {
	description = "Espacio de direcciones para la red virtual."
	type        = list(string)
	default     = ["10.0.0.0/16"]
}

variable "subnet_prefixes" {
	description = "Prefijos de subred para la subred de la VM."
	type        = list(string)
	default     = ["10.0.1.0/24"]
}

variable "allowed_ssh_cidr" {
	description = "Cidr permitido para acceso SSH a la VM."
	type        = string
	sensitive   = true
}

variable "acr_sufix" {
	description = "Sufijo para el nombre del Azure Container Registry."
	type        = string
	default     = "hubacr"
}

variable "acr_sku" {
	description = "SKU del Azure Container Registry (Basic, Standard, Premium)."
	type        = string
	default     = "Basic"
}

variable "acr_admin_enabled" {
	description = "Habilitar credenciales de administrador para el ACR."
	type        = bool
	default     = true
}

variable "aks_sku_tier" {
	description = "SKU tier del AKS (Free, Standard, Premium)."
	type        = string
	default     = "Standard"
}

variable "aks_subnet_prefix" {
	description = "Prefijo de subred para la subnet del AKS."
	type        = list(string)
	default     = ["10.0.2.0/24"]
}

variable "aks_node_count" {
	description = "Numero de nodos en el pool de nodos por defecto del AKS."
	type        = number
	default     = 1
}

variable "aks_vm_size" {
	description = "Tamanio de VM para los nodos del AKS."
	type        = string
	default     = "Standard_B2s"
}

variable "aks_service_cidr" {
	description = "CIDR del servicio de kubernetes."
	type        = string
	default     = "10.1.0.0/16"
}

variable "aks_dns_service_ip" {
	description = "IP del servicio DNS de kubernetes."
	type        = string
	default     = "10.1.0.10"
}

variable "aks_identity_type" {
	description = "Tipo de identity para el AKS (SystemAssigned o UserAssigned)."
	type        = string
	default     = "SystemAssigned"
}