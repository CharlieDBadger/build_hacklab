# 🛠️ VirtualBox Host-Only Auto Setup para Kali Linux y Windows

Este repositorio automatiza la configuración de red **Host-Only** entre una máquina anfitriona Windows y una máquina virtual **Kali Linux** en **VirtualBox**, ideal para entornos de laboratorio de ciberseguridad (pentesting, sniffing, análisis de tráfico, etc.).



## 📦 Contenido

- `configurar_vbox_red_local y firewall.ps1`: Script PowerShell para configurar VirtualBox y la red Host-Only en Windows.
- `red_kali.sh`: Script Bash para configurar automáticamente la red en Kali Linux usando DHCP.
- `README.md`: Esta guía paso a paso.



## ⚙️ Requisitos

### 🪟 Windows

- [VirtualBox](https://www.virtualbox.org/) instalado.
- Ejecutar PowerShell como **administrador**.
- La VM debe llamarse exactamente `"Kali"` o puedes ajustar el script con el nombre correcto.

### 🐧 Kali Linux

- Acceso como `root` o uso de `sudo`.
- Interfaz de red configurada para recibir IP por **DHCP**.
- Máquina virtual ya creada y con adaptador de red disponible.



## ✅ Instrucciones de Uso

### 🖥️ 1. Ejecutar en el host Windows

## 🛠️ Configuración inicial: PowerShell y red de VirtualBox

> ⚠️ **Importante:** Antes de ejecutar el script de configuración de red en PowerShell, asegúrate de permitir la ejecución de scripts locales. Si no haces esto, PowerShell bloqueará la ejecución por motivos de seguridad.

### 📌 Pasos para permitir y ejecutar el script

1. **Abre PowerShell como administrador**  
   Pulsa Inicio, busca `PowerShell`, haz clic derecho sobre el resultado y selecciona **"Ejecutar como administrador"**.

2. **Ubícate en la carpeta donde tienes el script**

3. **Cambia la política de ejecución para esta sesión**  
   Esto permite ejecutar scripts locales sin firma:

   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope Process
Responde **"Sí"** o **"Sí a todo"** cuando se te pregunte, este cambio solo afectará la terminal que tienes abierta.

4. **Ejecuta el script de red**  
   Lanza el script con:

   ```powershell
   .\configurar_vbox_red_local_y_firewall.ps1

Este script:

- Añade VirtualBox al PATH (si no está configurado).
- Crea un adaptador Host-Only (`vboxnet0`) si no existe.
- Configura IP y máscara de red.
- Activa servidor DHCP en ese adaptador.
- Conecta la red Host-Only a la VM `"Kali"`.
- Establece el perfil de red como Privado.
- Añade reglas al firewall de Windows para permitir tráfico en la red `192.168.56.0/24`.

> ⚠️ **Importante:** Cambia `"Ethernet 2"` en el script si tu adaptador Host-Only tiene otro nombre. Puedes verlo con `Get-NetAdapter`.



### 🐧 2. Ejecutar en la VM Kali Linux

```bash
# Dar permisos de ejecución al script
chmod +x red_kali.sh

# Ejecutar como root o con sudo
sudo ./red_kali.sh
```

Este script:

- Detecta automáticamente la interfaz activa (excepto `lo`).
- Limpia la configuración IP previa.
- Solicita IP al servidor DHCP del host.
- Verifica conexión con el host (`ping 192.168.56.1`).



## 🎯 Resultado Esperado

- Kali recibe una IP del rango `192.168.56.101 - 192.168.56.254`.
- Puede comunicarse con el host (`192.168.56.1`) sin acceso a Internet.
- Entorno funcional para prácticas de ciberseguridad en red local.



## 🧰 Solución de Problemas

| Problema                                 | Posible solución |
|------------------------------------------|------------------|
| `VBoxManage` no se reconoce              | Verifica que VirtualBox esté instalado y usa el path absoluto en el script. |
| Kali no recibe IP                       | Verifica si el DHCP en el host está activo y si la VM está conectada a `vboxnet0`. |
| Sin conectividad Kali ↔ Host            | Revisa el firewall de Windows, la interfaz activa y haz ping entre máquinas. |
| VM no llamada "Kali"                    | Cambia el nombre en el script o renombra tu VM en VirtualBox. |



## 📎 Notas adicionales

- Puedes adaptar estos scripts para otros sistemas Linux o para múltiples VMs.
- El script **no sobrescribirá** adaptadores existentes, solo crea uno si no existe.
