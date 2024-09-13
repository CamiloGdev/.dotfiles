$adminCheck = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

if (-Not $adminCheck) {
    Write-Host "Error: Este script debe ejecutarse en modo administrador." -ForegroundColor Red
    exit
}
else {
    Write-Host "Modo administrador verificado. Continuando..." -ForegroundColor Green
}

# Ruta base donde se encuentra el script
$scriptPath = (Get-Location).Path
$dotfilesPath = Split-Path -Parent $scriptPath

# Rutas relativas a verificar
$localNvimPath = Join-Path $dotfilesPath "nvim"
$psProfilePath = Join-Path $dotfilesPath "\powershell\Microsoft.PowerShell_profile.ps1"

# Ruta a la carpeta de destino en AppData
$nvimLinkPath = Join-Path $HOME "AppData\Local\nvim"
$profileLinkPath = $PROFILE

# --- Proceso para el enlace simbólico de PowerShell ---
# Verificar si el archivo de configuración de PowerShell existe en los dotfiles
if (Test-Path $psProfilePath) {
    Write-Host "El archivo 'Microsoft.PowerShell_profile.ps1' existe. Procediendo con la creación del enlace simbólico para el perfil de PowerShell..." -ForegroundColor Green

    # Verificar si la carpeta para el archivo $PROFILE de windows existe, y crearla si no existe
    $profileDir = Split-Path -Parent $profileLinkPath
    if (-Not (Test-Path $profileDir)) {
        Write-Host "La carpeta de perfil de PowerShell no existe. Creando la carpeta..." -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $profileDir
    }

    # Si ya existe un archivo o enlace simbólico en la ruta del perfil en windows, eliminarlo
    if (Test-Path $profileLinkPath) {
        Write-Host "El archivo o enlace simbólico en la ruta del perfil ya existe. Eliminando..." -ForegroundColor Yellow
        Remove-Item -Path $profileLinkPath
    }

    # Crear el enlace simbólico para el perfil de PowerShell
    Write-Host "Creando el enlace simbólico para el perfil de PowerShell..." -ForegroundColor Green
    New-Item -ItemType SymbolicLink -Path $profileLinkPath -Value $psProfilePath
}
else {
    Write-Host "El archivo 'Microsoft.PowerShell_profile.ps1' no existe en el directorio del script. Se omite la creación del enlace simbólico para el perfil de PowerShell." -ForegroundColor Red
}

# --- Proceso para el enlace simbólico de nvim ---
# Verificar si la carpeta nvim existe en los dotfiles
if (Test-Path $localNvimPath) {
    Write-Host "La carpeta 'nvim' existe. Procediendo con la creación del enlace simbólico para Neovim en AppData..." -ForegroundColor Green

    # Si ya existe un archivo o enlace simbólico en AppData\Local\nvim, eliminarlo
    if (Test-Path $nvimLinkPath) {
        Write-Host "La carpeta o enlace simbólico nvim ya existe en AppData. Eliminando..." -ForegroundColor Yellow
        Remove-Item -Path $nvimLinkPath -Recurse
    }

    # Crear el enlace simbólico para la carpeta nvim en AppData
    Write-Host "Creando el enlace simbólico para la carpeta nvim en AppData..." -ForegroundColor Green
    New-Item -ItemType SymbolicLink -Path $nvimLinkPath -Value $localNvimPath
}
else {
    Write-Host "La carpeta 'nvim' no existe en el directorio del script. Se omite la creación del enlace simbólico para Neovim." -ForegroundColor Red
}

Write-Host "Proceso completado." -ForegroundColor Cyan
