# Ruta base de VirtualBox
$VBoxPath = "C:\Program Files\Oracle\VirtualBox"

# Añadir VBoxManage al PATH si no está
if (-not ($env:Path -like "*$VBoxPath*")) {
    $env:Path += ";$VBoxPath"
    Write-Host "[+] VBoxManage añadido temporalmente al PATH." -ForegroundColor Green
}

# Configuración
$vmName = "kali"
$adapterName = "vboxnet0"
$interfaceAlias = "Ethernet 2"  # ⚠️ Cambia esto por el nombre real del adaptador Host-Only
$hostIP = "192.168.56.1"
$netmask = "255.255.255.0"
$dhcpStart = "192.168.56.101"
$dhcpEnd = "192.168.56.254"
$dhcpServerIP = "192.168.56.100"

try {
    # Crear adaptador Host-Only si no existe
    Write-Host "[*] Comprobando si existe el adaptador $adapterName..." -ForegroundColor White
    if (-not ((VBoxManage list hostonlyifs) -match $adapterName)) {
        Write-Host "[*] Creando adaptador $adapterName..." -ForegroundColor White
        VBoxManage hostonlyif create | Out-Null
        Write-Host "[✓] Adaptador creado." -ForegroundColor Green
    } else {
        Write-Host "[✓] El adaptador ya existe." -ForegroundColor Green
    }

    # Configurar IP del adaptador
    Write-Host "[*] Configurando IP en $adapterName..." -ForegroundColor White
    VBoxManage hostonlyif ipconfig $adapterName --ip $hostIP --netmask $netmask
    Write-Host "[✓] IP configurada correctamente." -ForegroundColor Green

    # Configurar servidor DHCP
    Write-Host "[*] Comprobando configuración de DHCP..." -ForegroundColor White
    if (-not ((VBoxManage list dhcpservers) -match $adapterName)) {
        VBoxManage dhcpserver add --ifname $adapterName --ip $dhcpServerIP --netmask $netmask --lowerip $dhcpStart --upperip $dhcpEnd --enable
        Write-Host "[✓] Servidor DHCP creado." -ForegroundColor Green
    } else {
        VBoxManage dhcpserver modify --ifname $adapterName --enable
        Write-Host "[✓] Servidor DHCP habilitado." -ForegroundColor Green
    }

    # Asignar adaptador a la VM
    Write-Host "[*] Asignando $adapterName a la VM '$vmName'..." -ForegroundColor White
    VBoxManage modifyvm $vmName --nic1 hostonly --hostonlyadapter1 $adapterName
    Write-Host "[✓] Adaptador asignado correctamente." -ForegroundColor Green

    # Activar DHCP en la interfaz de Windows
    Write-Host "[*] Activando DHCP en '$interfaceAlias'..." -ForegroundColor White
    netsh interface ip set address name="$interfaceAlias" source=dhcp
    Write-Host "[✓] DHCP activado." -ForegroundColor Green

    # Establecer red como privada
    Write-Host "[*] Cambiando red a perfil privado..." -ForegroundColor White
    Set-NetConnectionProfile -InterfaceAlias $interfaceAlias -NetworkCategory Private
    Write-Host "[✓] Perfil de red actualizado." -ForegroundColor Green

    # Reglas de firewall
    Write-Host "[*] Comprobando reglas de firewall..." -ForegroundColor White
    if (-not (Get-NetFirewallRule -DisplayName "Allow Host-Only Inbound" -ErrorAction SilentlyContinue)) {
        New-NetFirewallRule -DisplayName "Allow Host-Only Inbound" -Direction Inbound -Action Allow -RemoteAddress "$hostIP/24" -Profile Private
        Write-Host "[✓] Regla INBOUND creada." -ForegroundColor Green
    }

    if (-not (Get-NetFirewallRule -DisplayName "Allow Host-Only Outbound" -ErrorAction SilentlyContinue)) {
        New-NetFirewallRule -DisplayName "Allow Host-Only Outbound" -Direction Outbound -Action Allow -RemoteAddress "$hostIP/24" -Profile Private
        Write-Host "[✓] Regla OUTBOUND creada." -ForegroundColor Green
    }

    Write-Host "`n✅ Configuración completada correctamente para '$vmName'." -ForegroundColor Green

} catch {
    Write-Host "`n[✗] Error durante la configuración: $($_.Exception.Message)" -ForegroundColor Red
}
