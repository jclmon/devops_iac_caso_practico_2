# Rol ACR Image Management

Rol de Ansible para gestionar imágenes en Azure Container Registry (ACR) con organización por carpetas.

## Funcionalidades

- Login a ACR usando credenciales
- Descarga de imágenes desde repositorio público (Docker Hub) con etiqueta `:latest`
- Re-tagging automático a `:casopractico2` (etiqueta estándar del proyecto)
- Tagging de imágenes organizadas por carpetas funcionales (databases/, frontend/, custom/)
- Push de imágenes etiquetadas al ACR en su carpeta correspondiente

## Requisitos

- Azure Container Registry creado por Terraform
- Docker/Podman instalado en la máquina que ejecuta Ansible
- Colección `containers.podman` instalada: `ansible-galaxy collection install containers.podman`
- Archivo `inventory` generado por Terraform con variables del ACR

## Estructura

```
Ansible/
├── acr_playbook.yml                    # Playbook para ejecutar el rol
├── roles/
│   └── acr/
│       ├── tasks/main.yml              # Tasks principales
│       ├── vars/main.yml               # Variables del rol
│       ├── defaults/main.yml           # Valores por defecto
│       ├── handlers/main.yml           # Handlers
│       └── README.md                   # Documentación del rol
└── inventory                           # Generado por Terraform (incluye ACR)
```

## Ejecutar el playbook con variables del inventario

```bash
ansible-playbook -i inventory acr_playbook.yml
```

## Variables disponibles del inventario

El archivo `inventory` generado por Terraform proporciona:

- `acr_login_server`: URL del servidor ACR (ej: myregistry.azurecr.io)
- `acr_name`: Nombre del ACR (ej: jclmoniaccasopractico2hubacr)
- `acr_username`: Usuario admin del ACR (heredado de Terraform)
- `acr_password`: Contraseña admin del ACR (heredada de Terraform)
