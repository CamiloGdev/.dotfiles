# Configuración de `AutoHOtKey`

1. Instalar [AutoHotKey](https://www.autohotkey.com/)
2. Abrir la carpeta de auto ejecución del sistema (Win + R, shell:startup), o '~\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup'
3. Crear los accesos directos al los scripts de AutoHotKey en la carpeta de auto ejecución del sistema, los scripts se encuentran en la carpeta `AutoHotKey` del repositorio

## Alternativa para la crear los accesos directos ejecutando un script de PowerShell

1. Abrir PowerShell como administrador
2. Ejecutar el script `Create-AHKStartupLinks.ps1`, el script crea enlaces simbólicos en la carpeta de auto ejecución del sistema
