# Ansible

## Requisitos Previos

### Requisitos de Sistema

- **Python 3.8+**
- **Ansible 2.12+**
- **kubectl** configurado (para AKS)
- **podman** instalado (para ACR)
- **Azure CLI** configurado

### Colecciones Galaxy Requeridas

```bash
# Instalar colecciones necesarias PRIMERO
ansible-galaxy collection install -r requirements.yml
```

**Colecciones instaladas:**

- `containers.podman` - Gestión de imágenes Podman
- `kubernetes.core` - Operaciones de Kubernetes
- `azure.azcollection` - Integración con Azure
- `community.general` - Utilidades generales
- `ansible.posix` - Herramientas POSIX

## Estructura del Proyecto

```
ansible/
├── requirements.yml          # Dependencias de Galaxy
├── inventory.tmpl            # Template de inventario
├── main_playbook.yml         # Playbook principal
├── aks_playbook.yml          # Deploy en AKS
├── acr_playbook.yml          # Gestión de ACR
├── vm_playbook.yml           # Configuración de VM
├── roles/
│   ├── acr/                  # Azure Container Registry
│   ├── aks/                  # Azure Kubernetes Service
│   └── vm/                   # Virtual Machine
└── keys/                     # SSH keys (git-ignored)
```

## Archivos Generados

- **inventory**: Inventario dinámico de hosts (generado por Terraform)
- **keys/id_rsa**: Clave privada SSH
- **requirements.yml**: Especificación de colecciones Galaxy
- **SETUP.md**: Guía completa de configuración

## Estructura del Inventario

El inventario generado incluye grupos para:

- `[local]`: localhost con ansible_connection=local
- `[azure_vms]`: Máquina virtual de Azure con SSH
- `[acr]`: Azure Container Registry (local connection)
- `[aks]`: Azure Kubernetes Service (local connection) con kubeconfig local

## Flujo de Trabajo

1. **Terraform genera archivos**:

   ```bash
   cd ../terraform
   terraform apply
   # Genera: inventory, keys/id_rsa, kubeconfig
   ```

2. **Instalar dependencias Galaxy**:

   ```bash
   cd ../ansible
   ansible-galaxy collection install -r requirements.yml
   ```

3. **Ejecutar playbooks**:

   ```bash
   ansible-playbook -i inventory aks_playbook.yml
   ```

   **Gestión de imágenes en ACR:**

   ```bash
   ansible-playbook -i inventory acr_playbook.yml
   ```

   **Configuración de VM:**

   ```bash
   ansible-playbook -i inventory vm_playbook.yml
   ```

   **Todos los componentes:**

   ```bash
   ansible-playbook -i inventory main_playbook.yml
   ```

## Roles

### ACR Role

- Pull imágenes públicas desde Docker Hub
- Re-tag con versión `casopractico2`
- Tag con estructura de carpetas en ACR
- Push a Azure Container Registry
- Build imagen custom de nginx

**Variables principales:**

- `acr_login_server`: URL del ACR
- `acr_username`: Usuario admin de ACR
- `acr_password`: Contraseña de ACR

### VM Role

- Actualizar repositorios
- Instalar Podman y dependencias
- Login a ACR
- Deploy contenedor como servicio systemd

**Variables principales:**

- `container_image`: Imagen Docker a deployar
- `container_name`: Nombre del contenedor

### AKS Role

- Crear namespace en Kubernetes
- Crear ACR secret para image pull
- Crear PersistentVolumeClaim
- Deploy Redis database
- Deploy aplicación principal
- Crear LoadBalancer Service

**Variables principales:**

- `namespace`: Nombre del namespace
- `redis_memory_request`, `redis_cpu_request`: Recursos de Redis
- `app_memory_request`, `app_cpu_request`: Recursos de aplicación
- `replicas`: Número de replicas de la aplicación
