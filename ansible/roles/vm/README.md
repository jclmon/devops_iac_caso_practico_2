# Rol VM Web Server

Este rol de Ansible configura una máquina virtual de Azure y despliega un contenedor desde ACR como servicio systemd.

## Funcionalidades

- Asegurar Python3 instalado (primera tarea, prerequisito de Ansible)
- Actualizar repositorios APT (con sudo)
- Instalar Podman (con sudo)
- Login a ACR (credenciales persistentes)
- Pull de imagen custom desde ACR: `custom/nginx-custom:casopractico2`
- Crear archivo de servicio systemd: `/etc/systemd/system/nginx-app.service`
- Habilitar servicio para auto-inicio en reboot
- Iniciar servicio nginx-app con `ansible.builtin.systemd`
- Verificar estado del servicio y mostrar logs sin `shell`

## Requisitos

- Máquina virtual de Linux en Azure (Ubuntu 20.04+)
- Clave SSH configurada para acceso a la VM
- Azure Container Registry con imágenes disponibles
- Colección `containers.podman` instalada: `ansible-galaxy collection install containers.podman`
- Archivo `inventory` generado por Terraform con datos de la VM

## Estructura

```
Ansible/
├── vm_playbook.yml                     # Playbook para ejecutar el rol
├── roles/
│   └── vm/
│       ├── tasks/main.yml              # Tasks principales
│       ├── vars/main.yml               # Variables del rol
│       ├── defaults/main.yml           # Valores por defecto
│       ├── handlers/main.yml           # Handlers
│       └── README.md                   # Documentación del rol
└── inventory                           # Generado por Terraform (incluye VM)
```

## Ejecutar el playbook

```bash
ansible-playbook -i inventory vm_playbook.yml
```

## Variables

### Requeridas

```yaml
container_image: "myregistry.azurecr.io/custom/nginx-custom:casopractico2" # Imagen desde ACR con carpeta
acr_login_server: "myregistry.azurecr.io"
acr_username: "admin_username"
acr_password: "admin_password"
container_name: "nginx-app" # Nombre del contenedor y servicio
container_port: 80 # Puerto expuesto
```

### Variables del Rol (`roles/vm/defaults/main.yml`)

```yaml
# ACR connection details
acr_login_server: "" # URL servidor ACR
acr_username: "" # Usuario admin ACR
acr_password: "" # Contraseña admin ACR

# Container configuration
container_name: "app-container"
container_image: "" # Imagen completa: ACR/folder/image:tag
container_port: 80 # Puerto del contenedor

# Volume mount configuration
volume_mount_path: "/var/container/data"
auth_file_path: "/etc/container/auth/htpasswd"

# Basic authentication
basic_auth_username: "admin"
basic_auth_password: "changeme"

# Podman configuration
podman_executable: "podman"
apt_update_cache: true
apt_cache_valid_time: 3600
```
