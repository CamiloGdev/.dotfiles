# Author: Camilo Galeano (camilodev)
# Description: This is the profile for PowerShell 7.0.0 and later versions.

# Initializes oh-my-posh with themes from the theme library that are defined in the POSH_THEMES_PATH environment variable.
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/star.omp.json" | Invoke-Expression
#oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/emodipt-extend.omp.json" | Invoke-Expression
#oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/pure.omp.json" | Invoke-Expression

# Import the Terminal-Icons module for enhanced terminal icons
Import-Module Terminal-Icons

# Set the PSReadLine prediction view style to ListView
Set-PSReadLineOption -PredictionViewStyle ListView

# Set the PSReadLine prediction view style to ListView
Set-PSReadLineOption -PredictionViewStyle ListView

# Set configuration for fzf, activation and shortcuts
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# ---------- START cargar aliases ----------
# Obtener la ruta del archivo actual
$currentScriptPath = $MyInvocation.MyCommand.Path

# Verificar si el archivo es un enlace simbólico
$symlink = Get-Item $currentScriptPath

# Comprobar si el archivo tiene la propiedad 'Target' (lo que significa que es un enlace simbólico)
if ($symlink.PSIsContainer -eq $false -and $symlink -and $symlink.PSDrive.Provider.Name -eq 'FileSystem' -and $symlink.Target) {
    # Obtener la ruta real del archivo al que apunta el enlace simbólico
    $realProfilePath = $symlink | Select-Object -ExpandProperty Target
    Write-Host "El archivo es un enlace simbólico. La ruta real es: $realProfilePath"
} else {
    # Si no es un enlace simbólico, usar la ruta actual
    $realProfilePath = $currentScriptPath
    Write-Host "El archivo no es un enlace simbólico. La ruta es: $realProfilePath"
}

# Obtener el directorio del archivo de perfil real
$profileDirectory = Split-Path -Parent $realProfilePath

# Ruta relativa a aliases.ps1
$aliasesPath = Join-Path $profileDirectory "aliases.ps1"

# Verificar si el archivo aliases.ps1 existe y cargarlo
if (Test-Path $aliasesPath) {
    . $aliasesPath
    Write-Host "Aliases cargados desde: $aliasesPath"
} else {
    Write-Host "No se encontró el archivo de alias: $aliasesPath"
}
# ---------- END cargar aliases ----------


