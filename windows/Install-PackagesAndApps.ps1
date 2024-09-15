# ----- START Instalación de scoop -----
# Función para verificar si Scoop ya está instalado
function Test-ScoopInstalled {
    # Verifica si el comando 'scoop' está disponible en el sistema
    $scoopPath = (Get-Command scoop -ErrorAction SilentlyContinue)

    # Si la ruta de scoop existe, está instalado
    if ($scoopPath) {
        return $true
    }
    return $false
}

# Separador visual para la instalación de Scoop
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Instalacion del programa: Scoop" -ForegroundColor Cyan

# Verificar si Scoop ya está instalado
if (Test-ScoopInstalled) {
    Write-Host "El programa Scoop ya está instalado. Pasando al siguiente..." -ForegroundColor Green
}
else {
    Write-Host "Instalando $programId..." -ForegroundColor Yellow

    # Establecer política de ejecución
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

    # Ejecutar la instalación de Scoop
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}
# ----- END Instalación de scoop -----

# --- START Instalación de programas con winget ---
# Definir una lista de programas con su respectivo ID y flags de instalación
$programs = @(
    @{ Id = "Git.Git"; Flags = "-e --source winget" },
    @{ Id = "JanDeDobbeleer.OhMyPosh"; Flags = "-s winget" },
    @{ Id = "Neovim.Neovim"; Flags = "" },
    @{ Id = "Schniz.fnm"; Flags = "" },
    @{ Id = "Flow-Launcher.Flow-Launcher"; Flags = "" }
    @{ Id = "Python.Python.3.12"; Flags = "" }
)

# Función para verificar si un programa ya está instalado
function Test-ProgramInstalled {
    param (
        [string]$programId
    )

    # Ejecutar el comando winget list directamente en la consola
    Start-Process -FilePath "winget" -ArgumentList "list --id $programId" -NoNewWindow -Wait

    # Ejecuta winget para ver si el programa está instalado
    # $result = winget list --id $programId 2>&1
    $result = winget list --id $programId 2>&1

    # Verifica si el programa está en la lista de programas instalados
    if ($result -like "*$programId*") {
        return $true
    }
    return $false
}

# Bucle para recorrer los programas y realizar la instalación si es necesario
foreach ($program in $programs) {
    $programId = $program.Id
    $flags = $program.Flags

    # Imprimir un separador para indicar el inicio de un nuevo programa
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "Instalacion del programa: $programId" -ForegroundColor Cyan

    # Verificar si el programa ya está instalado
    if (Test-ProgramInstalled -programId $programId) {
        Write-Host "El programa $programId ya está instalado. Pasando al siguiente..." -ForegroundColor Green
    }
    else {
        Write-Host "Instalando $programId..." -ForegroundColor Yellow

        # Ejecutar el comando winget con las flags proporcionadas
        $command = "winget install -e --id $programId $flags"
        Invoke-Expression $command
    }
}
# --- END Instalación de programas con winget ---

# Refrescar las variables de entorno desde el sistema
$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ";" + [System.Environment]::GetEnvironmentVariable('Path', 'User')

# Recargar el perfil actual de PowerShell
". $PROFILE" | Invoke-Expression

# --- START Instalación de Node.js con fnm ---

# download and install Node.js
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Instalacion del programa: Node" -ForegroundColor Cyan

# Definir la versión de Node.js que se desea instalar
$NodeVersion = "20"

$nodeCommand = Get-Command node -ErrorAction SilentlyContinue

# Función para verificar si Node.js está instalado
function NodeInstalled {
    return $null -ne $nodeCommand
}

# Función para verificar si Node.js está instalado con fnm
function NodeInstalledWithFNM {
    if ( $null -ne $nodeCommand) {
        return $nodeCommand.Source -match "fnm"
    }
    return $false
}

# Función para obtener la versión de Node.js instalada actualmente
function Get-NodeVersion {
    $nodeVersionOutput = node --version 2>$null
    if ($nodeVersionOutput) {
        return $nodeVersionOutput.TrimStart("v")
    }
    return $null
}

# Verificar si Node.js está instalado
if (NodeInstalled) {
    Write-Host "Node.js está instalado."

    # Verificar si Node.js está instalado con fnm
    if (NodeInstalledWithFNM) {
        Write-Host "Node.js está instalado con fnm."

        # Obtener la versión instalada actualmente
        $currentVersion = Get-NodeVersion

        if ($currentVersion -eq $NodeVersion) {
            Write-Host "La versión $NodeVersion de Node.js ya está instalada y activa."
        }
        else {
            Write-Host "La versión instalada es $currentVersion, pero se necesita la versión $NodeVersion."
            Write-Host "Instalando la versión $NodeVersion con fnm..."
            "fnm use --install-if-missing $NodeVersion" | Invoke-Expression
        }
    }
    else {
        Write-Host "Error: Node.js está instalado sin fnm." -ForegroundColor Red
        Write-Host "Por favor, desinstala la versión actual de Node.js manualmente antes de continuar." -ForegroundColor Yellow
        Write-Host "Una vez desinstalado, puedes instalar la versión $NodeVersion de Node.js con el siguiente comando:" -ForegroundColor Cyan
        $commandMessage = "fnm use --install-if-missing $NodeVersion"
        Write-Host "`$ $commandMessage" -ForegroundColor Cyan
    }
}
else {
    Write-Host "Node.js no está instalado. Instalando Node.js versión $NodeVersion con fnm..."
    "fnm use --install-if-missing $NodeVersion" | Invoke-Expression
}

Write-Host "==================================================" -ForegroundColor Cyan
# --- END Instalación de Node.js con fnm ---
