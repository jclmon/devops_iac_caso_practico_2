# ACR Role

Rol de Ansible para gestionar imágenes en Azure Container Registry (ACR) con organización por carpetas.

## Funcionalidades

- ✅ Login a ACR usando credenciales
- ✅ Descarga de imágenes desde repositorio público (Docker Hub) con etiqueta `:latest`
- ✅ Re-tagging automático a `:casopractico2` (etiqueta estándar del proyecto)
- ✅ Tagging de imágenes organizadas por carpetas funcionales (databases/, frontend/, custom/)
- ✅ Push de imágenes etiquetadas al ACR en su carpeta correspondiente

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
public_images: # Lista de imágenes públicas a descargar y organizar
  - image: "docker.io/bitnami/redis:latest"
    folder: "databases" # Carpeta en ACR
    tag_version: "casopractico2" # Etiqueta
  - image: "docker.io/suhuruli/azure-vote-front:latest"
    folder: "frontend"
    tag_version: "casopractico2"
  - image: "docker.io/library/nginx:latest"
    folder: "custom"
    tag_version: "casopractico2"

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
- `pull_images`: Descarga imágenes públicas con etiqueta `:latest`
- `retag_images`: Re-tagea imágenes a `:casopractico2`
- `tag_images`: Organiza y tagea para ACR con estructura de carpetas
- `push_images`: Push de imágenes a ACR a sus carpetas respectivas

Ejecutar solo un tag:

```bash
ansible-playbook -i inventory playbook.yml --tags "pull_images"
ansible-playbook -i inventory playbook.yml --tags "retag_images,push_images"
```

## Flujo de Imágenes (Caso Práctico 2)

```
1. Pull :latest        → bitnami/redis:latest
2. Re-tag :casopractico2 → redis:casopractico2
3. Tag con carpeta     → ACR/databases/redis:casopractico2
4. Push al ACR         → Imagen disponible para VM y AKS
```

Esto se repite para cada imagen en `public_images`.

## Dependencias

- Ansible >= 2.10
- `containers.podman` collection
- Docker/Podman instalado en la máquina que ejecuta el rol

## Notas de seguridad

- Las credenciales del ACR deben pasar por variables seguras (vault, variables secas)
- Nunca hardcodies contraseñas en el playbook
- Usa `ansible-vault` para encriptar archivos con credenciales
