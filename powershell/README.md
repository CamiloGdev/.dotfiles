# Configuración y personalización de `Windows Terminal` y `PowerShell 7`

## Personalización de `Windows Terminal`

1. Adicionar el tema Catppuccin frappe en el archivo de configuración de Windows Terminal `settings.json`
   * [Catppuccin para Windows Terminal](https://github.com/catppuccin/windows-terminal)
   * El tema se debe poner tanto en los colores para la terminal como en el tema para la aplicación de Windows Terminal
2. Establecer PowerShell 7 como `Perfil predeterminado` en configuraciones de `Inicio`
3. Establecer Windows Terminal como `Aplicación de terminal predeterminada` en configuraciones de `Inicio`
4. Establecer `Centrar al inicio` en la configuración de Windows Terminal en configuraciones de `Inicio`
5. Establecer `Tamaño al inicio` en la configuración de Windows Terminal en configuraciones de `Inicio`
6. Establecer Catppuccin Frappé como tema de `Tema de la aplicación` en configuraciones de `Apariencia`
7. Activar `Usar material acrílico en la fila de tabulación` en configuraciones de `Apariencia`
8. Establecer Catppuccin Frappé como `Combinación de colores` en `Valores predeterminados/Apariencia`
9. Establecer `FiraCode Nerd Font Mono` como `Tipo de fuente`, o la fuente que se desee en `Valores predeterminados/Apariencia`
10. Activar `Habilitar material acrílico` en la configuración de Windows Terminal en `Valores predeterminados/Apariencia`
11. Configurar ruta de inicio predeterminada para el perfil de PowerShell 7 si es necesario

## Configuración de `PowerShell 7`

Es recomendable instalar primero los plugins antes de generar el enlace simbólico para que las configuraciones contenidas en el perfil no de error al iniciar la terminal

1. Instalar [`scoop` command-line installer for Windows] para instalar paquetes sin requerir elevación de permisos de administrador
   * [Scoop](https://scoop.sh/)
2. Instalar algunos paquetes importantes con `scoop`: `scoop install curl sudo jp`
3. Instalar fzf con scoop: `scoop install fzf`
4. Instalar módulo de PowerShell 7 para fzf: `Install-Module -Name PSFzf -Scope CurrentUser -Force`
   * Establecer las opciones de fzf en el perfil de PowerShell 7: `Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'`
   Nota: Esta configuración ya está incluida en el archivo de configuración del perfil.
5. Instalar módulo Directory Jumper `z`: `Install-Module -Name z -Force`
6. Instalar módulo de iconos para la terminal `Terminal-Icons` desde PSGallery: `Install-Module -Name Terminal-Icons -Repository PSGallery`
   * Importar módulo de iconos en el archivo de perfil: `Import-Module Terminal-Icons`
   Nota: Esta configuración ya está incluida en el archivo de configuración del perfil.

7. Crear enlace simbólico para el archivo de configuración del perfil de PowerShell 7:

   Antes de establecer el link simbólico para la configuración del perfil, la ruta al archivo debe existir, es decir la carpeta; para crear la carpeta ejecutamos el siguiente comando:
      El comando crea la carpeta para el archivo $PROFILE en caso de que no exista, y en caso de que ya exista arroja el error.

      ```powershell
      New-Item -ItemType Directory -Path (Split-Path -Parent $PROFILE)
      ```

   * Crear enlace simbólico (desde PowerShell como administrador):

      ```powershell
      New-Item -ItemType SymbolicLink -Path $PROFILE -Value <ruta al archivo de configuración>
      ```

   * En caso de error por que el archivo ya existe, eliminar el archivo y volver a crear el enlace simbólico

      ```powershell
      Remove-Item -Path $PROFILE
      ```

8. instalación y configuración inicial de [Oh My Posh](https://ohmyposh.dev/docs/installation/windows#installation), con winget

9. Cambio de tema de Oh My Posh
   * Usar comando para visualizar los temas disponibles en la galería: `Get-PoshThemes`

   * Poner la ruta del archivo en el archivo de configuración del perfil
   por ejemplo para usar el tema jandedobbeleer, alterar la línea init de la siguiente manera (powershell):

      ```powershell
      oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/jandedobbeleer.omp.json" | Invoke-Expression
      ```

   Nota: Esta configuración ya está incluida en el archivo de configuración del perfil.
