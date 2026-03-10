# AKS Role

Rol de Ansible para desplegar aplicaciones en Azure Kubernetes Service (AKS).

## Funcionalidades

- ✅ Obtener kubeconfig del cluster AKS
- ✅ Crear namespace
- ✅ Crear secreto para ACR (image pull secret)
- ✅ Crear ConfigMap para configuración
- ✅ Crear Persistent Volume Claim (PVC)
- ✅ Crear Redis Deployment (backend)
- ✅ Crear Redis Service (ClusterIP interno)
- ✅ Crear Frontend Deployment con:
  - Image pull secrets para ACR
  - Volume mount para datos persistentes
  - Resource requests y limits
  - Variable de entorno REDIS apuntando a redis-service
- ✅ Crear LoadBalancer Service
- ✅ Esperar a que se asigne IP externa
- ✅ Mostrar información del despliegue

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

## Variables Principales

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

### Configuración de Deployment

```yaml
namespace: "casopractico2"
replicas: 2
container_port: 80
redis_image: "jclmoniaccasopractico2hubacr.azurecr.io/databases/redis:casopractico2"
container_image: "jclmoniaccasopractico2hubacr.azurecr.io/frontend/azure-vote-front:casopractico2"
pvc_size: "10Gi"
etiqueta: "casopractico2" # Etiqueta estándar de todas las imágenes
```

## Flujo de Despliegue (Caso Práctico 2)

1. **Get Credentials**: Obtiene kubeconfig de AKS
2. **Create Namespace**: Crea namespace `casopractico2`
3. **Create ACR Secret**: Permite ACR descargar imágenes privadas con credenciales
4. **Create PVC**: Almacenamiento persistente de 10Gi
5. **Create ConfigMap**: Configuración de la app
6. **Create Redis**: Deployment con imagen `databases/redis:casopractico2`
7. **Create Redis Service**: ClusterIP service para conectividad interna (puerto 6379)
8. **Create Frontend**: Deployment con imagen `frontend/azure-vote-front:casopractico2` (2-3 réplicas)
9. **Create LoadBalancer**: Service para acceso externo (puerto 80)
10. **Wait for IP**: Espera asignación de IP externa (máx 5 minutos)
11. **Display Info**: Muestra información de acceso y verificación

## Variables de Entorno en Pods

- **Frontend pods** (etiqueta :casopractico2):
  - `REDIS=redis-service` - Conecta a Redis service interno
  - Imagen: `databases/redis:casopractico2`
- **Redis pod** (etiqueta :casopractico2):
  - `ALLOW_EMPTY_PASSWORD=yes` - Permite conexión sin password
  - Imagen: `frontend/azure-vote-front:casopractico2`

## Conectividad y Flujo

- **Frontend pods ↔ Redis service**: Via `redis-service` ClusterIP (interno, puerto 6379)
  - Frontend se conecta usando variable de entorno `REDIS=redis-service`
  - Ambos en el mismo namespace `casopractico2`
- **External users ↔ Frontend**: Via `app-service` LoadBalancer (puerto 80)
  - IP pública asignada automáticamente
  - Tráfico distribuido entre 2-3 replicas de Frontend

## Imágenes del Caso Práctico 2

Todas las imágenes utilizan la etiqueta `:casopractico2` y están organizadas en carpetas en el ACR:

- `databases/redis:casopractico2` - Backend Redis para almacenar votos
- `frontend/azure-vote-front:casopractico2` - Frontend con interfaz de votación

## Uso

### Opción 1: Con playbook

```yaml
---
- name: Deploy to AKS
  hosts: aks
  vars:
    resource_group_name: "myresourcegroup"
    aks_cluster_name: "myakscluster"
    acr_login_server: "myregistry.azurecr.io"
    acr_username: "admin_user"
    acr_password: "admin_password"
    container_image: "myregistry.azurecr.io/jclmoniaccasopractico2hubacr:latest"
    namespace: "production"
    replicas: 3
    pvc_size: "20Gi"
  roles:
    - aks
```

### Opción 2: Desde línea de comandos

```bash
ansible-playbook -i inventory aks_playbook.yml \
  -e "resource_group_name=myresourcegroup" \
  -e "aks_cluster_name=myakscluster" \
  -e "acr_login_server=myregistry.azurecr.io" \
  -e "container_image: "myregistry.azurecr.io/jclmoniaccasopractico2hubacr:latest""
```

## Tags

- `setup_kubeconfig`: Obtener kubeconfig
- `create_namespace`: Crear namespace
- `create_acr_secret`: Crear secreto de ACR
- `create_configmap`: Crear ConfigMap
- `create_pvc`: Crear Persistent Volume Claim
- `create_deployment`: Crear Deployment
- `create_service`: Crear LoadBalancer Service
- `wait_for_lb`: Esperar IP externa

Ejecutar solo ciertos tags:

```bash
ansible-playbook -i inventory aks_playbook.yml --tags "create_deployment,create_service"
```

## Recursos creados

### Secreto (ImagePullSecret)

- Tipo: `kubernetes.io/dockercfg`
- Uso: Permite a AKS descargar imágenes del ACR privado
- Nombre: `acr-secret` (configurable)

### ConfigMap

- Contiene variables de configuración de la aplicación
- Nombre: `app-config` (configurable)

### Persistent Volume Claim

- Tamaño: 10Gi (configurable)
- Almacenamiento: `default` storage class
- Modo de acceso: ReadWriteOnce
- Nombre: `app-pvc` (configurable)

### Deployment

- Replicas: 2 (configurable)
- Labels: `app: <app_name>`
- Includes health checks:
  - Liveness probe: `/health` cada 10s
  - Readiness probe: `/ready` cada 5s
- Resource management:
  - Requests: 100m CPU, 128Mi RAM
  - Limits: 500m CPU, 512Mi RAM
- Volume montado en `/data` (configurable)

### LoadBalancer Service

- Tipo: `LoadBalancer`
- Puerto: 80 (configurable)
- Asigna IP pública externa

## Flow de ejecución

1. Obtiene credenciales de AKS (`kubeconfig`)
2. Crea namespace
3. Crea secreto de ACR para autenticar pull de imágenes
4. Crea ConfigMap con variables de env
5. Crea PVC para almacenamiento persistente
6. Crea Deployment con:
   - Replicas del pod
   - Image pull secret
   - Volumen montado
   - Health checks
7. Crea LoadBalancer Service
8. Espera a que se asigne IP externa
9. Muestra información del despliegue

## Requisitos previos

1. **Ansible >= 2.10**

   ```bash
   pip install ansible
   ```

2. **Colección kubernetes.core**

   ```bash
   ansible-galaxy collection install kubernetes.core
   ```

3. **Azure CLI**

   ```bash
   # Windows/Linux
   az --version
   ```

4. **kubectl**

   ```bash
   az aks install-cli
   # O instalar manualmente
   ```

5. **Terraform apply completado**
   - AKS cluster debe estar creado y disponible

## Verificación manual

```bash
# Ver namespace
kubectl get namespaces

# Ver secretos
kubectl get secrets -n <namespace>

# Ver PVC
kubectl get pvc -n <namespace>

# Ver deployment
kubectl get deployment -n <namespace>

# Ver pods
kubectl get pods -n <namespace> -o wide

# Ver service
kubectl get service -n <namespace>

# Ver logs
kubectl logs -f deployment/<deployment_name> -n <namespace>

# Acceso a pod
kubectl exec -it pod/<pod_name> -n <namespace> -- /bin/bash
```

## Troubleshooting

### Error: "Unable to connect to the server"

```
Causa: kubeconfig inválido o cluster no accesible
Solución:
az aks get-credentials --resource-group myresourcegroup --name myakscluster
```

### Error: "ImagePullBackOff"

```
Causa: No puede descargar imagen del ACR
Solución:
1. Verificar credenciales de ACR
2. Verificar que la imagen existe en ACR: az acr repository list
3. Verificar permisos de pull del secreto
```

### Error: "Pending" en LoadBalancer

```
Causa: AKS aún asignando IP externa
Solución: Esperar un poco más (30s x 10 reintentos)
```

### Error: "PersistentVolumeClaim pending"

```
Causa: No hay PV disponible o storage class no existe
Solución:
1. Verificar storage classes: kubectl get storageclass
2. Crear PV manualmente si es necesario
```

## Actualizar despliegue

Para actualizar a nueva versión de imagen:

```bash
# Opcional: Cambiar imagen (Deployment se recrea)
ansible-playbook -i inventory aks_playbook.yml \
  --tags "create_deployment" \
  -e "container_image=myregistry.azurecr.io/nginx:v2"

# O restartear manualmente
kubectl rollout restart deployment/app-deployment -n default
```

## Eliminar recursos

```bash
# Eliminar via playbook (TODO: agregar task)
kubectl delete deployment app-deployment -n default
kubectl delete service app-service -n default
kubectl delete pvc app-pvc -n default
kubectl delete secret acr-secret -n default
```

## Seguridad

⚠️ **IMPORTANTE**:

- Las credenciales del ACR se almacenan en el secreto de Kubernetes
- El kubeconfig se guarda localmente
- Usa RBAC y Network Policies para restringir acceso
- Actualiza regularmente las imágenes y dependencias

```bash
# Ver RBAC
kubectl get rolebindings -n default
kubectl get clusterrolebindings
```
