# Script para revertir configuración Host-Only en Windows

# Cambiar nombre del adaptador según sea necesario
$adapterName = "Ethernet 2"

Write-Host "Revirtiendo configuración para adaptador $adapterName..." -ForegroundColor White

# Eliminar reglas firewall relacionadas con Host-Only
Get-NetFirewallRule -DisplayName "*Host-Only*" | Remove-NetFirewallRule -ErrorAction SilentlyContinue
Write-Host "Reglas de firewall para Host-Only eliminadas." -ForegroundColor Green

# Cambiar perfil de red a Public para mayor restricción
try {
    Set-NetConnectionProfile -InterfaceAlias $adapterName -NetworkCategory Public
    Write-Host "Perfil de red cambiado a Public." -ForegroundColor Green
} catch {
    Write-Host "No se pudo cambiar el perfil de red. Verifica que el adaptador exista." -ForegroundColor Red
}

# Configurar IP estática (ajusta la IP y máscara si quieres, aquí ejemplo sin DHCP)
try {
    netsh interface ip set address name="$adapterName" static 192.168.56.10 255.255.255.0
    Write-Host "IP estática configurada en $adapterName." -ForegroundColor Green
} catch {
    Write-Host "Error configurando IP estática." -ForegroundColor Red
}

Write-Host "Proceso de reversión completado." -ForegroundColor Green
