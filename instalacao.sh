#!/usr/bin/env bash
# ----------------------------- VARIÁVEIS ----------------------------- #
URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
URL_DISCORD="https://discordapp.com/api/download?platform=linux&format=deb"
URL_OPERA="https://download.opera.com/download/get/?partner=www&opsys=Linux"
DIRETORIO_DOWNLOADS="$HOME/Downloads/programas"

PROGRAMAS_PARA_INSTALAR=(
  flameshot
  steam-installer
  steam-devices
  steam:i386
  sublime-text
  code
  default-jdk
  git
  qbittorrent
  nodejs
  ttf-mscorefonts-installer
)
# ---------------------------------------------------------------------- #

# ----------------------------- REQUISITOS ----------------------------- #
## Removendo travas eventuais do apt ##
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

## Adicionando/Confirmando arquitetura de 32 bits ##
sudo dpkg --add-architecture i386

## Atualizando o repositório ##
sudo apt update && sudo apt upgrade -y

# ---------------------------------------------------------------------- #

# ----------------------------- EXECUÇÃO ----------------------------- #

## Download e instalaçao de programas externos ##
mkdir "$DIRETORIO_DOWNLOADS"
wget -c "$URL_GOOGLE_CHROME"       -P "$DIRETORIO_DOWNLOADS"
wget -c "$URL_DISCORD"       -P "$DIRETORIO_DOWNLOADS"
wget -c "$URL_OPERA"       -P "$DIRETORIO_DOWNLOADS"

## Instalando pacotes .deb baixados na sessão anterior ##
sudo dpkg -i $DIRETORIO_DOWNLOADS/*.deb

# Instalar programas no apt
for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    apt install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done

## Instalando pacotes Flatpak ##
flatpak install flathub org.gimp.GIMP -y
flatpak install flathub org.videolan.VLC -y

## Instalando pacotes Snap ##
sudo rm /etc/apt/preferences.d/nosnap.pref ## Removendo a trava de instalação de snaps do Mint 20.x ##
sudo apt update
sudo apt install snapd -y
sudo snap install scrcpy
# ---------------------------------------------------------------------- #

# ----------------------------- PÓS-INSTALAÇÃO ----------------------------- #
## Finalização, atualização e limpeza##
sudo apt remove gimp -y
apt remove vlc -y
apt remove pidgin -y
apt remove hexchat -y
apt remove cheese -y
apt remove celluloid -y
apt remove transmission -y
sudo apt update && sudo apt dist-upgrade -y
flatpak update -y
sudo apt autoclean -y
sudo apt autoremove -y
echo "Fim da configuração, por favor reinicie o computador"
# ---------------------------------------------------------------------- #
