#!/bin/bash

# === Configuración de red para adaptador Host-Only en Kali Linux ===

# Colores
BLANCO='\033[1;37m'
VERDE='\033[0;32m'
ROJO='\033[0;31m'
RESET='\033[0m'

# Detectar interfaz automáticamente (excepto loopback)
INTERFAZ=$(ip -o link show | awk -F': ' '{print $2}' | grep -v 'lo' | head -n1)

echo -e "${BLANCO}[*] Detectando interfaz de red...${RESET}"
if [ -z "$INTERFAZ" ]; then
    echo -e "${ROJO}[✗] No se encontró ninguna interfaz de red disponible.${RESET}"
    exit 1
else
    echo -e "${VERDE}[✓] Interfaz detectada: $INTERFAZ${RESET}"
fi

echo -e "${BLANCO}[*] Limpiando configuraciones anteriores...${RESET}"
sudo ip addr flush dev "$INTERFAZ"

echo -e "${BLANCO}[*] Solicitando IP vía DHCP...${RESET}"
sudo dhclient "$INTERFAZ"
if [ $? -eq 0 ]; then
    echo -e "${VERDE}[✓] DHCP completado con éxito.${RESET}"
else
    echo -e "${ROJO}[✗] Fallo al obtener IP por DHCP.${RESET}"
    exit 1
fi

# Probar conectividad con la puerta de enlace típica de VirtualBox Host-Only
GATEWAY="192.168.56.1"
echo -e "${BLANCO}[*] Verificando conectividad con el host (${GATEWAY})...${RESET}"
ping -c 2 "$GATEWAY" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${VERDE}[✓] Conexión establecida correctamente con el host.${RESET}"
else
    echo -e "${ROJO}[✗] No se pudo contactar con el host (${GATEWAY}).${RESET}"
fi
