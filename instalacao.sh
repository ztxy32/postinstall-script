#!/usr/bin/env bash
# ----------------------------- VARIÁVEIS ----------------------------- #
URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
URL_DISCORD="https://discordapp.com/api/download?platform=linux&format=deb"
URL_OPERA="https://download.opera.com/download/get/?partner=www&opsys=Linux"
DIRETORIO_DOWNLOADS="$HOME/Downloads/programas"

PROGRAMAS_PARA_INSTALAR=(
  flameshot
  code
  default-jdk
  git
  qbittorrent
  nodejs
)

# ----------------------------- REQUISITOS ----------------------------- #
## Removendo travas eventuais do apt ##
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

## Atualizando o repositório ##
sudo apt update && sudo apt upgrade -y


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
FLATPAKS_PARA_INSTALAR=(
  org.gimp.GIMP
  org.videolan.VLC
  io.github.shiftey.Desktop
  com.stremio.Stremio
  com.spotify.Client
  com.valvesoftware.Steam
)
for nome_do_programa in ${FLATPAKS_PARA_INSTALAR[@]}; do
  flatpak install flathub "$nome_do_programa" -y
done

# ----------------------------- PÓS-INSTALAÇÃO ----------------------------- #
## Finalização, atualização e limpeza##

REMOVER=(
  gimp
  vlc
  pidgin
  hexchat
  cheese
  celluloid
  transmission
)
for nome_do_programa in ${REMOVER[@]}; do
  apt remove "$nome_do_programa" -y
done

sudo apt update && sudo apt dist-upgrade -y
flatpak update -y
sudo apt autoclean -y
sudo apt autoremove -y
sudo apt install -f
echo "Fim da configuração, por favor reinicie o computador"
# ---------------------------------------------------------------------- #
