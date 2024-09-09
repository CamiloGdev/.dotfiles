# Definir las rutas de los archivos
$sourceDir = (Get-Location).Path  # La carpeta donde está el script
$startupFolder = [System.IO.Path]::Combine($env:APPDATA, "Microsoft\Windows\Start Menu\Programs\Startup")

# Definir los archivos
$files = @("en-US_accents.ahk", "js-remapkeys.ahk")

foreach ($file in $files) {
    # Rutas completas del archivo y del enlace simbólico
    $sourcePath = [System.IO.Path]::Combine($sourceDir, $file)
    $linkPath = [System.IO.Path]::Combine($startupFolder, $file)

    # Verificar si el archivo de origen existe
    if (-not (Test-Path $sourcePath)) {
        Write-Host "El archivo $file no se encuentra en la carpeta del script. Abortando..." -ForegroundColor Red
        continue
    }

    # Verificar si el enlace ya existe
    if (Test-Path $linkPath) {
        Write-Host "El enlace o archivo $file ya existe en la carpeta de inicio. No se realizará ninguna acción." -ForegroundColor Yellow
        continue
    }

    # Crear el enlace simbólico
    try {
        New-Item -Path $linkPath -ItemType SymbolicLink -Target $sourcePath
        Write-Host "Enlace simbólico para $file creado correctamente en $startupFolder." -ForegroundColor Green
    } catch {
        Write-Host ("Error al crear el enlace simbólico para " + $file + ": " + $_.Exception.Message) -ForegroundColor Red
    }
}
