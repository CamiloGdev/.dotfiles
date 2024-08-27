# Configuración de Oh My Posh

## Instalación y configuración inicial de Oh My Posh

   [Instalar Oh My Posh](https://ohmyposh.dev/docs/installation/windows)

## Fuente Nerd Font

   Instalar la fuente FiraCode Mono - [Nerd Fonts](https://www.nerdfonts.com/font-downloads)

## Crear enlace simbólico para la configuración del perfil de PowerShell

1. Abrir la terminal de PowerShell como administrador
2. Crear enlace simbólico con el comando

   ```powershell
   New-Item -ItemType SymbolicLink -Path $PROFILE -Value C:\Users\chcam\AppData\Local\nvim\Oh_My_Posh\Microsoft.PowerShell_profile.ps1
   ```

3. En caso de error por que el archivo ya existe, eliminar el archivo y volver a crear el enlace simbólico

   ```powershell
   Remove-Item -Path $PROFILE
   ```

## Cambio de tema de Oh My Posh

1. Escoger de la biblioteca de temas:

   - Usar comando para visualizar los temas disponibles en la galería

      ```powershell
      Get-PoshThemes
      ```

   - Poner la ruta del archivo en el archivo de configuración del perfil
   por ejemplo para usar el tema jandedobbeleer, alterar la línea init de la siguiente manera (powershell):

      ```powershell
      oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/jandedobbeleer.omp.json" | Invoke-Expression
      ```

2. Usar tema personalizado:

   por ejemplo para usar el tema camilodev basado en la paleta de colores Catppuccin, alterar la línea init de la siguiente manera (powershell):

   ```powershell
   oh-my-posh init pwsh --config "~\AppData\Local\nvim\Oh_My_Posh\camilodev.omp.json" | Invoke-Expression
   ```

> **!NOTE**
> esta configuración ya esta incluida en el archivo de configuración del perfil

## Módulo de iconos

- Instalar modulo Terminal-Icons desde PSGallery

   ```powershell
   Install-Module -Name Terminal-Icons -Repository PSGallery
   ```

- Agregar línea en el archivo de perfil para cargar el módulo

   ```powershell
   Import-Module Terminal-Icons
   ```

   > **!NOTE**
   > esta configuración ya esta incluida en el archivo de configuración del perfil

## Módulo Predicción de comandos

- Agregar líneas en el archivo de perfil para activar predicción por vista de lista

   ```powershell
   Set-PSReadLineOption -PredictionViewStyle ListView
   ```

   > **!NOTE**
   > esta configuración ya esta incluida en el archivo de configuración del perfil

## Reiniciar la configuración de powershell

   Reiniciar la configuración de PowerShell para que los cambios surtan efecto

   ```powershell
   . $PROFILE
   ```
