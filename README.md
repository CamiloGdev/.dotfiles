# Configuración del Entorno de Desarrollo

## Instalaciones Iniciales del Sistema

1. Instalar winget
2. Instalar PowerShell 7
3. Instalar Git

## Instalar AutoHOtKey

1. Instalar AutoHotKey
2. Abrir la carpeta de auto ejecución del sistema (Win + R, shell:startup), o '~\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup'
3. Crear los accesos directos al los scripts de AutoHotKey en la carpeta de auto ejecución del sistema

## Personalización del Sistema

1. Instalar tema Catppuccin Frappé para navegador
2. Instalar fuentes:
   - [Cascadia Code](https://github.com/microsoft/cascadia-code/releases)
   - FiraCode Mono - [Nerd Fonts](https://www.nerdfonts.com/font-downloads)
   - MesloLGS NF - [Nerd Fonts](https://www.nerdfonts.com/font-downloads)

## Configuración de Visual Studio Code

1. Activar sincronización
2. Esperar carga de configuraciones y atajos personalizados
3. Instalar plugins recomendados (ubicados en la carpeta vscodeRecommended)

## Personalización del Escritorio

1. Instalar Wallpaper Engine ó Live Wallpaper
2. Configurar fondo de pecera con peces koi

## Configuración de Windows Terminal

1. Instalar Windows Terminal
2. Establecer PowerShell 7 como terminal predeterminada
3. Configurar ruta de inicio predeterminada
4. Ajustes visuales:
   - Fuente: Fira Code Mono
   - Ajustar transparencia: 45%
5. Instalar y configurar tema Catppuccin Frappé
   - [Configuraciones del tema Catppuccin para Windows Terminal](https://github.com/catppuccin/windows-terminal)
   - El tema se debe poner tanto en los colores para la terminal como en el tema para la aplicación de Windows Terminal

## Configuración de Neovim

1. [Instalar Neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md#windows)
2. Clonar repositorio de configuraciones:

   [Ir al Repositorio](https://github.com/CamiloGdev/neovim-config)

   ```powershell
   git clone git@github.com:CamiloGdev/neovim-config.git ~\AppData\Local\nvim
   ```

   - Windows: `~\AppData\Local\nvim\`
   - Linux: `~/.config/nvim/`
   - macOS: `~/.config/nvim/`
3. El administrador de paquetes lazy.nvim ya está configurado en los archivos del repositorio

## Instalación de Oh My Posh

- Seguir pasos en  el README de la carpeta de Oh My Posh

## Herramientas Adicionales

1. Instalar y configurar CLI de Copilot
