# 🧪 Fase 2: Instalación del Laboratorio en Red

Esta fase consiste en montar un entorno de pruebas con **Metasploitable 2** dentro de VirtualBox. Es una máquina vulnerable ideal para practicar técnicas de pentesting en un entorno controlado.

---

## 🐚 1. Descargar Metasploitable 2 (.vmdk)

- Descarga el archivo `.vmdk` de Metasploitable 2 desde su fuente oficial:  
  🔗 [https://sourceforge.net/projects/metasploitable/](https://sourceforge.net/projects/metasploitable/)
- Descomprime el archivo `.zip` o `.7z`.
- **Recomendación:** Mueve el archivo `.vmdk` a la misma carpeta donde tienes las demás máquinas virtuales de VirtualBox (puedes ver la ruta al crear una nueva VM, en el apartado **Carpeta**).  
  ⚠️ **Importante:** Si borras el archivo `.vmdk`, perderás la máquina del laboratorio.

---

## 📦 2. Crear nueva VM en VirtualBox

- Abre VirtualBox y haz clic en **Nueva**.
- Asigna un nombre a la VM (por ejemplo: `metasploitable-lab`).
- Tipo: `Linux`
- Versión: `Other Linux (32-bit)`
  
![Crear mvlab](/./fase2.1.png)

---

## ⚙️ 3. Ajustar recursos de hardware

- Memoria base: `1024 MB` (1 GB)
- CPU: `1 núcleo`

Esta máquina no requiere demasiados recursos ya que solo usaremos la terminal.

---

## 💾 4. Conectar el disco duro existente

- En la sección **Disco duro**, selecciona:  
  `Usar un archivo de disco duro existente`.
- Haz clic en el icono de carpeta 📁 > Añadir > busca el archivo `.vmdk` descomprimido > **Aceptar**.

🚫 **¡No inicies la máquina aún!** Hay que configurar la red primero.

---

## 🌐 5. Configurar la red de la VM

- Entra a **Configuración** de la máquina virtual.
- Sección **Red**:
  - **Conectado a**: `Adaptador solo anfitrión (Host-only Adapter)`
  
Con esto, tu máquina Metasploitable estará en la **misma red virtual** que tu sistema anfitrión (Windows) y tu Kali Linux, permitiendo escaneo y ataques en red local desde Kali.

---

✅ Con esto ya tienes lista la base del laboratorio para iniciar prácticas de reconocimiento, escaneo y explotación.

> Próximo paso: Validar la red y comenzar con los escaneos Nmap desde Kali 🎯
