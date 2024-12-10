#!/bin/bash

#actualizar linux
sudo apt-get autoremove -y
sudo apt-get update -y
sudo apt-get upgrade -y

#INSTALACION DE PAQUETES ESENCIALES
sudo apt-get install -y \
    bash zsh zgen sudo wget g++ make gnupg gnupg2 ca-certificates lsb-release \
    vim neovim nano libbrotli-dev cmake \
    ccze jq jc less catimg nnn ranger zoxide \
    tldr httpie man googler ddgr neofetch screenfetch \
    htop ncdu icdiff \
    unzip zip bzip2 p7zip-full \
    locales locales-all \
    bat eza \
    sl lolcat cmatrix ffmpeg \
    stow

#DETALLES DE PAQUETES INSTALADOS
    # sudo (complemento para usuario root puede no estar en todas las distros)
    # bash zsh (Shells)
    # zgen (instalador plugins zsh)
    # wget (descarga con links)
    # g++ make gnupg gnupg2 ca-certificates (Herramientas de complación)
    # lsb-release (version de LINUX)
    # vim nano (editores)
    # libbrotli-dev cmake (compresores)
    # ccze (colorea la salida de texto)
    # jq (procesador de JSON)
    # jc (formatea un JSON obtenido, o convierte algo a JSON)
    # less (paginador para la consola)
    # catimg (ver imagenes en el terminal)
    # nnn ranger (moverse por ficheros)
    # zoxide (lleva a rutas segun historial, es como el z de oh my zsh)
    # man (ayudas para comandos linux)
    # tldr (es un "man" resumido, con ejemplos)
    # httpie (un curl mejorado, para acceder a cosas)
    # googler ddgr (busquedas en consola)
    # neofetch screenfetch (visualiza logo de distro e información de sistema)
    # htop (top mas bonito)
    # ncdu (espacio ocupado por ficheros)
    # icdiff (diferencias entre ficheros)
    # unzip zip bzip2 p7zip-full (compresores)
    # locales locales-all (paquetes de localización, error: character not in range)
    # bat (un cat mas bonito)
    # exa (un ls mas bonito)
    # sl (tren por escribir mal ls)
    # lolcat (pinta con arcoiris la salida de texto)
    # cmatrix (efecto consola matrix)
    # ffmpeg (editor de audio y video en consola)
    # stow (linckea los fichetos de configuración que estan en mi .dotfiles)

# Fix batcat -> bat
sudo ln -s /usr/bin/batcat /usr/local/bin/bat

#instalamos fzf, completado inteligente con búsqueda avanzada
# se debe realizar la instalación manual de fzf por medio del script de instalación para obtener la última versión y tener acceso a los atajos de teclado de manera simple
# clonar el repositorio de fzf en la carpeta .fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
## Ejecutar el script de instalación
yer | ~/.fzf/install

# Oh-my-zsh
# la instalación establece zsh como shell por defecto
yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# instalar plugins para zsh (quedan en la carpeta CUSTOM de oh my zsh)
# (zsh-autosuggestions): Sugerencias basadas en el historial
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# (zsh-syntax-highlighting): Resaltado de sintaxis para comandos
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# (zsh-completions): Auto completado mejorado para comandos, agrega auto completado adicional que no esta incluido en el auto completado de comandos que trae zsh
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions

# instalar y establecer el THEME deseado
# ...

## --------- STOW ---------
#comando stow para linckear los archivos de configuración
#analiza directoiros en dotfiles, segun estos borra los del sistema y linckea a los de dotfiles.
cd $HOME/.dotfiles

mkdir -p ~/.dotfiles/backups

# crear directorio de configuración de nvim en caso de que no exista y linkear archivos de configuración
mkdir -p ~/.config
stow -R nvim -t ~

# hacer backup de .zshrc y linkear el archivo de configuración desde dotfiles
mv ~/.zshrc ~/.dotfiles/backups/
stow -R zsh

# reiniciar zsh para que se apliquen los cambios
source $HOME/.zshrc
cd
## --------- STOW ---------

# ejecutar zsh
zsh

# instalar node con el gestor de versiones fnm pero estando en zsh
# ...
