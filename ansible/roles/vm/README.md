# VM Role

Rol de Ansible para configurar una VM de Azure como servicio systemd persistente.

## Funcionalidades

- ✅ Actualizar repositorios APT (con sudo)
- ✅ Instalar Podman (con sudo)
- ✅ Login a ACR (credenciales persistentes)
- ✅ Pull de imagen custom desde ACR: `custom/nginx-custom:casopractico2`
- ✅ Crear archivo de servicio systemd: `/etc/systemd/system/nginx-app.service`
- ✅ Habilitar servicio para auto-inicio en reboot
- ✅ Iniciar servicio nginx-app
- ✅ Verificar estado del servicio y mostrar logs

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

### Opcionales

```yaml
service_name: "nginx-app" # Nombre del servicio systemd
service_file: "/etc/systemd/system/nginx-app.service" # Ruta del archivo de servicio
restart_policy: "always" # Reiniciar si falla
```

## Uso

### Opción 1: Con playbook

```yaml
---
- name: Configure and deploy on VM
  hosts: azure_vms
  become: yes
  vars:
    container_image: "myregistry.azurecr.io/nginx:latest"
    acr_login_server: "myregistry.azurecr.io"
    acr_username: "admin_user"
    acr_password: "admin_password"
    container_name: "web-app"
    container_port: 80
    volume_mount_path: "/data/www"
    basic_auth_username: "webadmin"
    basic_auth_password: "secure_password"
  roles:
    - vm
```

### Opción 2: Desde línea de comandos

```bash
ansible-playbook -i inventory vm_playbook.yml \
  -e "container_image=myregistry.azurecr.io/nginx:latest" \
  -e "acr_login_server=myregistry.azurecr.io" \
  -e "acr_username=admin_user" \
  -e "acr_password=admin_password"
```

## Tags

- `update_repos`: Actualizar repositorios
- `install_podman`: Instalar Podman
- `setup_volume`: Crear directorio de volumen
- `acr_login`: Login a ACR
- `pull_image`: Descargar imagen
- `create_auth`: Crear archivo de autenticación
- `start_container`: Iniciar contenedor
- `enable_autostart`: Configurar auto-inicio
- `verify_container`: Verificar estado

Ejecutar solo ciertos tags:

```bash
ansible-playbook -i inventory vm_playbook.yml --tags "install_podman,pull_image"
```

## Flujo de ejecución (Systemd)

1. **Actualiza repositorios** - `apt update`
2. **Instala Podman** - Instala Podman y dependencias
3. **Login a ACR** - Autentica con credenciales para acceso privado
4. **Pull imagen** - Descarga `custom/nginx-custom:casopractico2` desde ACR
5. **Crea servicio systemd**:
   - Archivo: `/etc/systemd/system/nginx-app.service`
   - Type: simple (supervisa el proceso Podman)
   - ExecStart: `podman run` el contenedor nginx
   - Restart: always (reinicia si falla)
6. **Recarga systemd** - Luego de crear/modificar el archivo de servicio
7. **Habilita servicio** - `systemctl enable nginx-app` (auto-inicio en reboot)
8. **Inicia servicio** - `systemctl start nginx-app`
9. **Verifica estado** - Comprueba con `systemctl status nginx-app`

## Gestión del Servicio

Desde cualquier administrador con acceso SSH:

```bash
# Iniciar servicio
sudo systemctl start nginx-app

# Detener servicio
sudo systemctl stop nginx-app

# Reiniciar servicio
sudo systemctl restart nginx-app

# Ver estado
sudo systemctl status nginx-app

# Ver logs
sudo journalctl -u nginx-app -f
```

## Ejemplos prácticos

### Desplegar nginx desde ACR

```yaml
vars:
  container_image: "myregistry.azurecr.io/nginx:latest"
  container_name: "web-server"
  container_port: 80
  volume_mount_path: "/srv/web"
  basic_auth_username: "nginx"
  basic_auth_password: "nginx123"
```

### Desplegar aplicación personalizada

```yaml
vars:
  container_image: "myregistry.azurecr.io/myapp:v1.0"
  container_name: "my-app"
  container_port: 8080
  volume_mount_path: "/app/data"
  basic_auth_username: "appuser"
  basic_auth_password: "app_secure_pass"
```

## Requisitos previos

1. **Ansible >= 2.10**

   ```bash
   pip install ansible
   ```

2. **Colección containers.podman**

   ```bash
   ansible-galaxy collection install containers.podman
   ```

3. **Sistema Ubuntu/Debian**
   - El rol usa `apt` (gestor de paquetes Debian)

4. **Acceso SSH con permisos sudoers**
   - Se necesita ejecutar comandos con `sudo`

5. **Terraform apply completado**
   - VM debe estar creada y accesible por SSH

## Notas de seguridad

⚠️ **IMPORTANTE**:

- Las credenciales del ACR se pasan en variables. Usa `ansible-vault` para proteger valores sensibles
- El archivo htpasswd se crea localmente, considera usar un archivo pre-generado
- La contraseña básica debe ser fuerte y no hardcodearse
- El volumen montado debe tener permisos restrictos

```bash
# Encriptar playbook
ansible-playbook -i inventory vm_playbook.yml --ask-vault-pass
```

## Troubleshooting

### Error: "apt: command not found"

Este rol está diseñado para Ubuntu/Debian. Para CentOS/RHEL, modifica las tareas de instalación a usar `yum` en lugar de `apt`.

### Error: "failed to pull image"

Verifica que:

1. Las credenciales de ACR son correctas
2. La imagen existe en el ACR
3. La conexión a Internet es disponible

```bash
az acr repository list --name myregistry
```

### Error: "Cannot create volume directory"

Asegúrate de tener permisos sudoers en la VM:

```bash
sudo mkdir -p /var/container/data
sudo chmod 755 /var/container/data
```

## Próxima ejecución

Para actualizar el contenedor sin reprovisionar:

```bash
# Solo pull y restart
ansible-playbook -i inventory vm_playbook.yml --tags "pull_image,restart_container"
```
