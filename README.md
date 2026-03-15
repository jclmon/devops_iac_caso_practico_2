# DevOps & Cloud IaC Caso Práctico 2

## Descripción General

Proyecto de automatización completa que despliega una aplicación de votación distribuida en Azure utilizando:

- **Terraform**: Infrastructure as Code - Provisiona VMs, ACR, AKS
- **Ansible**: Configuration Management - Gestiona aplicaciones y configuración
- **Azure**: Cloud Provider
- **Kubernetes**: Orquestación de contenedores (AKS)
- **Podman**: Contenedores en VM

## Arquitectura

```
┌─────────────────────────────────────────────────────┐
│        AZURE - Región: spaincentral                 │
│                                                     │
│  ┌──────────────────┐        ┌──────────────────┐   │
│  │  VM (Podman)     │        │   AKS Cluster    │   │
│  │  ─────────────   │        │  ──────────────  │   │
│  │ • nginx-custom   │        │ • Redis Deploy   │   │
│  │   (systemd)      │        │ • azure-vote     │   │
│  │ • Port 80        │        │ • LoadBalancer   │   │
│  └──────────────────┘        └──────────────────┘   │
│                                                     │
│  ACR: Imágenes Organizadas por Carpeta              │
│  ├─ databases/redis:casopractico2                   │
│  ├─ frontend/azure-vote-front:casopractico2         │
│  └─ custom/nginx-custom:casopractico2               │
│                                                     │
└─────────────────────────────────────────────────────┘
```

## Quick Start

### 1. Provisionar Infraestructura

```bash
cd terraform
terraform init
terraform apply
```

### 2. Cargar Imágenes en ACR

```bash
cd ../ansible
ansible-playbook -i inventory acr_playbook.yml
```

### 3. Desplegar en VM (Podman)

```bash
ansible-playbook -i inventory vm_playbook.yml
```

### 4. Desplegar en AKS (Kubernetes)

```bash
ansible-playbook -i inventory aks_playbook.yml
```

### 5. Acceder a la Aplicación

```bash
# Obtener LoadBalancer IP
kubectl get svc app-service -n casopractico2

# Acceder
open http://<EXTERNAL-IP>
```

## Estructura (Archivos)

### VERSIONADOS EN GIT

```
terraform/
├── main.tf
├── vars.tf
├── outputs.tf
├── terraform.tfvars.example      ← Dummy values
├── *.tf (todas las infraestructura)

ansible/
├── *.yml (playbooks)
├── inventory.tmpl
├── roles/*/tasks/*.yml
├── roles/*/defaults/*.yml
├── roles/*/README.md
└── ACR_INTEGRATION.md, etc.
```

### NO VERSIONADOS (.gitignore)

```
Terraform/
├── terraform.tfvars              ← Credenciales reales
├── .terraform/                   ← Directorio de plugins
├── *.tfstate                     ← State files
└── tfplan                        ← Plan files

Ansible/
├── inventory                     ← Generado dinámicamente + IPs reales
├── keys/                         ← SSH keys privadas
└── ~/.kube/config               ← Kubeconfig local
```

---

## Seguridad

Todos los secretos están protegidos por `.gitignore`:

- `terraform.tfvars` - Credenciales de Terraform
- `ansible/inventory` - Variables sensibles
- `ansible/keys/` - Claves SSH privadas

## Requisitos

- **Python >=3.8**
- **Terraform >= v1.0**
- **Ansible >= v2.9**
- **kubectl** configurado (para AKS)
- **podman** instalado (para ACR)
- **Azure CLI** configurado
