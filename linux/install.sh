#!/bin/bash

#actualizar linux
sudo apt-get autoremove -y
sudo apt-get update -y
sudo apt-get upgrade -y

#INSTALACION DE PAQUETES ESENCIALES
sudo apt-get install -y \
    bash zsh zgen sudo wget g++ make gnupg gnupg2 ca-certificates lsb-release \
    vim nano libbrotli-dev cmake \
    ccze jq jc less catimg nnn ranger zoxide \
    tldr httpie man googler ddgr neofetch screenfetch \
    htop ncdu icdiff \
    unzip zip bzip2 p7zip-full \
    locales locales-all \
    bat exa \
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
    # nnn ranger (moverse poro ficheros)
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

# Oh-my-zsh
yes | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# instalar plugins para zsh (quedan en la carpeta CUSTOM de oh my zsh)
# (zsh-autosuggestions): Sugerencias basadas en el historial
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# (zsh-syntax-highlighting): Resaltado de sintaxis para comandos
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# (zsh-completions): Autocompletado mejorado para comandos
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions

#instalar POWERLEVEL10K THEME
#con el stow se agrega la linea al .zshrc (source ~/powerlevel10k/powerlevel10k.zsh-theme) para ser activado
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

#instalamos fzf, completado inteligente con búsqueda avanzada
sudo apt-get install -y fzf

# Node/NPM/PNPM install
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash #Instala gestor de ver de node, nvm
source $HOME/.zshrc
source $HOME/.nvm/nvm.sh
nvm install node #instala la version estable de node
npm install -g #Instala algunos paquetes importantes de node, por aghora no hay ninguno que considere importante

#comando stow para linckear los archivos de configuración
#analiza directoiros en dotfiles, segun estos borra los del sistema y linckea a los de dotfiles.
cd $HOME/.dotfiles/stow
stow --target=$HOME *
source $HOME/.zshrc
cd

# ejecutar zsh
zsh
