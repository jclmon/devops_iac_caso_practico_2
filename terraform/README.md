# Estructura de Terraform - Caso Práctico 2

## Resumen Ejecutivo

La carpeta `terraform/` contiene la **Infraestructura como Código (IaC)** que define y despliega todos los recursos en Azure necesarios para el caso práctico. Esta configuración está separada en archivos modulares para facilitar su mantenimiento y reutilización.

---

## 1. Propósito General

**Objetivo Principal:**
Provisionar automáticamente la infraestructura completa en Azure, incluyendo:

- ✅ Grupo de recursos (Resource Group)
- ✅ Registro de contenedores privado (ACR)
- ✅ Máquinas virtuales Linux (VM)
- ✅ Cluster de Kubernetes (AKS)
- ✅ Redes virtuales y subredes
- ✅ Direcciones IP públicas
- ✅ Grupos de seguridad de red (NSGs)
- ✅ Configuración de RBAC y permisos

**Ventajas:**

- 🔄 Reproducible: mismo código = misma infraestructura
- 📝 Versionable: cambios rastreables en Git
- 🔒 Consistencia: elimina errores manuales
- 🚀 Rápido: despliegue en minutos
- 💾 Recuperable: documentación ejecutable

---

## 2. Estructura de Archivos

```
terraform/
├── main.tf                    # Configuración principal y providers
├── vars.tf                    # Definición de variables de entrada
├── terraform.tfvars           # Valores de variables (secreto, NO subir)
├── terraform.tfvars.example   # Plantilla de valores de ejemplo
├── outputs.tf                 # Salidas para exportar a Ansible
├── acr.tf                     # Azure Container Registry
├── aks.tf                     # Azure Kubernetes Service
├── aks_subnet.tf              # Subnet para AKS
├── vm_compute.tf              # Máquina virtual Linux
├── vm_nic.tf                  # Network Interface Controller de VM
├── vm_public_ip.tf            # IP pública para VM
├── vm_resource_group.tf       # Resource Group
├── vm_security_group.tf       # Security Group para VM
├── vm_security_rules.tf       # Reglas de seguridad
├── vm_subnet.tf               # Subnet para VM
├── vm_virtual_network.tf      # Virtual Network
├── inventory.tf               # Generación de inventario para Ansible
├── terraform.tfstate          # Estado actual (no editar, git-ignored)
├── terraform.tfstate.backup   # Backup del estado
└── .gitignore                 # (recomendado) Ignorar archivos sensibles
```

---

## 3. Flujo de Ejecución

### 3.1 Inicialización

```bash
# Descargar providers y modules
terraform init

# Resultado:
✓ Descarga Azure provider (~3.0)
✓ Descarga Random provider (~3.6)
✓ Crea .terraform/
✓ Bloquea versiones en .terraform.lock.hcl
```

### 3.2 Validación

```bash
# Verificar sintaxis
terraform validate

# Resultado:
✓ Success! The configuration is valid.
```

### 3.3 Planificación

```bash
# Crear plan de cambios
terraform plan -out=tfplan

# Resultado:
Plan: 20 to add, 0 to change, 0 to destroy.
```

**Plan detalla:**

- Recursos a crear/modificar/destruir
- Dependencias entre recursos
- Orden de ejecución
- Cambios esperados
