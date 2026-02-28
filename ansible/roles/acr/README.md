# ACR Role

Role de Ansible para gestionar imágenes en Azure Container Registry (ACR).

## Funcionalidades

- ✅ Login a ACR usando credenciales
- ✅ Descarga de imágenes desde repositorio público (Docker Hub)
- ✅ Tagging de imágenes con el nombre del servidor ACR
- ✅ Push de imágenes al ACR

## Variables

### Requeridas

```yaml
acr_login_server: "myregistry.azurecr.io" # URL del ACR
acr_username: "admin_username" # Usuario admin del ACR
acr_password: "admin_password" # Contraseña del ACR
acr_name: "myregistry" # Nombre del ACR
```

### Opcionales

```yaml
public_images: # Lista de imágenes públicas a descargar
  - "docker.io/library/nginx:latest"
  - "docker.io/library/ubuntu:22.04"
  - "docker.io/library/alpine:latest"

podman_executable: "podman" # Ejecutable de podman
```

## Uso

### Opción 1: Con playbook

```yaml
---
- name: Manage ACR images
  hosts: acr
  vars:
    acr_login_server: "{{ acr_login_server }}"
    acr_username: "{{ acr_admin_username }}"
    acr_password: "{{ acr_admin_password }}"
    acr_name: "{{ acr_name }}"
    public_images:
      - "docker.io/library/nginx:latest"
      - "docker.io/library/ubuntu:22.04"
  roles:
    - acr
```

### Opción 2: Desde línea de comandos

```bash
ansible-playbook -i inventory playbook.yml \
  -e "acr_login_server=myregistry.azurecr.io" \
  -e "acr_username=admin_user" \
  -e "acr_password=admin_password" \
  -e "acr_name=myregistry"
```

## Tags

- `acr_login`: Login a ACR
- `pull_images`: Descarga imágenes públicas
- `tag_images`: Tagea imágenes para ACR
- `push_images`: Push de imágenes a ACR

Ejecutar solo un tag:

```bash
ansible-playbook -i inventory playbook.yml --tags "pull_images"
```

## Dependencias

- Ansible >= 2.10
- `containers.podman` collection
- Docker/Podman instalado en la máquina que ejecuta el rol

## Notas de seguridad

- Las credenciales del ACR deben pasar por variables seguras (vault, variables secas)
- Nunca hardcodies contraseñas en el playbook
- Usa `ansible-vault` para encriptar archivos con credenciales
