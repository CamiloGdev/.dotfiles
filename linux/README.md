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
  * linkea .gitconfig
* instala NODE con control de versiones fnm, PDT incluir en el script

## Configuración de `Neovim`

   Revisar el archivo `README.md` en la carpeta `nvim` para la configuración de Neovim

## Instalar Docker en Ubuntu

Seguir los pasos de instalación usando apt repository de la página oficial de Docker

* [Install using the `apt` repository](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)

## (opcional) Instalar paquete de idioma

* (sudo apt-get install language-pack-es language-pack-es-base)
* (sudo update-locale LANG=es_CO.UTF-8)
