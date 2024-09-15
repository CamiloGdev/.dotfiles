# Configuración y personalización de `Neovim`

## Configuración de `Neovim` en Windows

1. [Instalar Neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md#windows), con winget, **lo hace el script de instalación**
2. Clonar repositorio de configuraciones:

    [Ir al Repositorio](https://github.com/CamiloGdev/neovim-config)

3. Crear enlace simbólico de la carpeta `nvim` en la ruta de configuración de Neovim: **lo hace el script de symlinkDotfiles.ps1**
    Para crear el enlace simbólico en Windows, se debe ejecutar PowerShell como administrador y ejecutar el siguiente comando:

   ```powershell
    New-Item -ItemType SymbolicLink -Path ~\AppData\Local\nvim -Value <ruta al repositorio>
   ```

   En caso de error por que la carpeta ya existe, eliminar la carpeta y volver a crear el enlace simbólico

   ```powershell
    Remove-Item -Path ~\AppData\Local\nvim
   ```

   * Windows: `~\AppData\Local\nvim\`

4. El administrador de paquetes lazy.nvim ya está configurado en los archivos del repositorio

## Configuración de `Neovim` en Linux

* Linux: `~/.config/nvim/`
* macOS: `~/.config/nvim/`
