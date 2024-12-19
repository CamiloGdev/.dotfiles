* configurar el tema de zsh con starship compararlo con el tema de oh my posh start
* consultar los atajos de teclado del plugin de autosuggestions
* instalación y configuración de tmux
* configuración completa de neovim
* instalar copilot para neovim

# Configuración de Linux

## Actualizar Ubuntu e instalar curl, git

* sudo apt-get update
* sudo apt-get upgrade
* sudo apt-get install curl git

## Clonar Repositorio de Configuraciones

   [Ir al Repositorio](https://github.com/CamiloGdev/.dotfiles)

## Ejecutamos el script (bash install.sh), este realiza lo siguiente (detalles dentro del script)

* instala paquetería esencial
* instala fzf
  * se instala de manera manual, se clona el repositorio y se ejecuta el script de instalación para tener de manera sencilla los atajos de teclado
  * la forma de **actualizarlo** es entrando a la carpeta de ~/.fzf, haciendo git pull y ejecutando el script de instalación de nuevo ~/.fzf/install
* instala Oh-my-zsh
* instala plugins de zsh
* ejecuta stow para linkear los dotfiles
  * linkea .zshrc que contiene el tema, los plugins, etc...
  * linkea .config/nvim que contiene la configuración de neovim

## Instalar `fnm` (Fast Node Manager)

[Instalación de fnm](https://github.com/Schniz/fnm?tab=readme-ov-file#installation)

* Actualización:
Actualizar fnm es casi lo mismo que instalarlo. Para evitar duplicaciones en tu archivo de configuración del shell, añade --skip-shell al comando de instalación.

## Configuración de `Neovim`

Revisar el archivo `README.md` en la carpeta `nvim` para la configuración de Neovim

## Instalar rust

* [Rust lang install web](https://www.rust-lang.org/es/tools/install)

## Instalar git hub copilot cli

* [GitHub Copilot CLI](https://docs.github.com/en/copilot/using-github-copilot/using-github-copilot-in-the-command-line)
* [GitHub CLI - Instalación](https://github.com/cli/cli/blob/trunk/docs/install_linux.md)
* [Installing GitHub Copilot in the GitHub CLI](https://docs.github.com/en/copilot/managing-copilot/configure-personal-settings/installing-github-copilot-in-the-cli#installing-copilot-in-the-cli)
* luego de instalar el CLI de GitHub copilot, ejecutamos el comando `gh copilot alias` para configurar el alias de copilot.
  [GitHub Copilot Alias](https://docs.github.com/es/copilot/managing-copilot/configure-personal-settings/configuring-github-copilot-in-the-cli#setting-up-aliases)

## Instalar Docker en Ubuntu

Seguir los pasos de instalación usando apt repository de la página oficial de Docker y luego los pasos de post-instalación para Linux para poder ejecutar comandos de Docker sin necesidad de `sudo`.

* [Install using the `apt` repository](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)
* [Post-installation steps for Linux](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user)

## (opcional) Instalar paquete de idioma

* (sudo apt-get install language-pack-es language-pack-es-base)
* (sudo update-locale LANG=es_CO.UTF-8)
