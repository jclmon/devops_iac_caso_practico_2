# Rol AKS Cluster Kubernetes

Rol de Ansible para desplegar aplicaciones en Azure Kubernetes Service (AKS).

## Funcionalidades

- Obtener kubeconfig del cluster AKS
- Crear namespace
- Crear secreto para ACR (image pull secret) con `kubernetes.core.k8s`
- Crear ConfigMap para configuración
- Crear Persistent Volume Claim (PVC)
- Crear Redis Deployment (backend) con recursos parametrizados
- Crear Redis Service (ClusterIP interno)
- Crear Frontend Deployment con:
  - Image pull secrets para ACR
  - Volume mount para datos persistentes
  - Resource requests y limits parametrizados
  - Variable de entorno REDIS apuntando a redis-service
- Crear LoadBalancer Service
- Esperar a que se asigne IP externa con `kubernetes.core.k8s_info + wait`
- Mostrar información del despliegue con módulos nativos

### Módulos Utilizados

- `kubernetes.core.k8s_info` - Consulta de recursos
- `kubernetes.core.k8s` - Creación/actualización de recursos
- `kubernetes.core.k8s` con patch - Restart de deployments
- Cero uso de `shell` o `command` en tasks principales

## Arquitectura

```
Frontend Pod 1 ──┐
                 ├─→ Redis Service (ClusterIP) ──→ Redis Pod
Frontend Pod 2 ──┘
                 ↓
          LoadBalancer Service
                 ↓
            External IP (80)
```

## Requisitos

- `kubernetes.core` >=2.0.0 - Kubernetes resource management
- `azure.azcollection` >=1.14.0 - Azure operations
- `community.general` >=5.0.0 - General utilities
- `ansible.posix` >=1.4.0 - POSIX tools

## Estructura

```
Ansible/
├── aks_playbook.yml                    # Playbook para ejecutar el rol
├── roles/
│   └── aks/
│       ├── tasks/main.yml              # Tasks principales
│       ├── vars/main.yml               # Variables del rol
│       ├── defaults/main.yml           # Valores por defecto
│       ├── handlers/main.yml           # Handlers
│       └── README.md                   # Documentación del rol
└── inventory                           # Generado por Terraform (incluye AKS)
```

## Ejecutar el playbook

```bash
ansible-playbook -i inventory aks_playbook.yml
```

## Variables

### Requeridas

```yaml
resource_group_name: "jclmon-iac-casopractico2-rg"
aks_cluster_name: "jclmon-iac-casopractico2-aks"
acr_login_server: "jclmoniaccasopractico2hubacr.azurecr.io"
acr_username: "admin"
acr_password: "<password>"
redis_image: "jclmoniaccasopractico2hubacr.azurecr.io/databases/redis:casopractico2"
container_image: "jclmoniaccasopractico2hubacr.azurecr.io/frontend/azure-vote-front:casopractico2"
```

### Variables del Rol (`roles/aks/defaults/main.yml`)

```yaml
# AKS and Azure configuration
resource_group_name: ""
aks_cluster_name: ""
kubeconfig_path: "~/.kube/config"

# ACR configuration
acr_login_server: ""
acr_username: ""
acr_password: ""
acr_secret_name: "acr-secret"

# Kubernetes configuration
namespace: "default"
app_environment: "production"

# Deployment configuration
deployment_name: "app-deployment"
app_name: "app"
container_name: "app-container"
container_image: "{{ acr_login_server }}/frontend/azure-vote-front:casopractico2"
redis_image: "{{ acr_login_server }}/databases/redis:casopractico2"
container_port: 80
container_mount_path: "/data"
replicas: 2

# Resource requests and limits
cpu_request: "100m"
memory_request: "128Mi"
cpu_limit: "500m"
memory_limit: "512Mi"

# Service configuration
service_name: "app-service"
service_port: 80

# Persistent Volume configuration
pvc_name: "app-pvc"
pvc_size: "10Gi"
storage_class: "default"

# ConfigMap configuration
app_config_name: "app-config"
log_level: "INFO"
```

## Recursos y Límites parametrizados

Todas las siguientes variables pueden ser sobrescritas para diferentes ambientes:

```yaml
# Redis
redis_replicas: 1
redis_memory_request: "64Mi"
redis_memory_limit: "256Mi"
redis_cpu_request: "50m"
redis_cpu_limit: "250m"

# Frontend App
app_memory_request: "64Mi"
app_memory_limit: "512Mi"
app_cpu_request: "100m"
app_cpu_limit: "500m"
```
