# Master Script to run all tasks in sequence

function Start-Script {
    param (
        [string]$scriptPath,
        [string]$description
    )

    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "$description" -ForegroundColor Yellow
    Write-Host "==================================================" -ForegroundColor Cyan
    try {
        & $scriptPath
        if ($?) {
            Write-Host "`nEl script '$scriptPath' se ejecutó correctamente." -ForegroundColor Green
        }
        else {
            Write-Host "`nHubo un error al ejecutar '$scriptPath'." -ForegroundColor Red
        }
    }
    catch {
        Write-Host "`nExcepción al ejecutar '$scriptPath': $_" -ForegroundColor Red
    }
    Write-Host "`n" # Add some spacing after each section
}

# Start the process

Write-Host "`n***** INICIO DE LA INSTALACIÓN *****" -ForegroundColor Cyan
Write-Host "`n"

# Run the scripts in sequence
Start-Script ".\Install-PackagesAndApps.ps1" "Instalación de aplicaciones y paquetes del sistema"
Start-Script ".\Install-PSPackagesAndPlugins.ps1" "Instalación de aplicaciones y módulos para PowerShell"
Start-Script ".\SymlinkDotfiles.ps1" "Creación de enlaces simbólicos a las configuraciones de PowerShell y Neovim"
Start-Script "..\AutoHotkey\Create-AHKStartupLinks.ps1" "Creación de enlaces simbólicos para scripts de mapeos del teclado (AutoHotkey)"

Write-Host "`n***** FINALIZADO EL PROCESO *****" -ForegroundColor Cyan
Write-Host "`n"
