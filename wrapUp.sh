#!/bin/bash

set -Eeo pipefail

echo $'\n**************************************************************\n                        * NAOS TTT *\n**************************************************************\n'
echo $'|   Guided installation   | \n'
echo $'Checking for Docker Requirements:\n'


check_linux (){
  OS_ID=$(. /etc/os-release && echo "$ID")
  OS_VER=$(. /etc/os-release && echo "$VERSION_ID")

  if [ $OS_ID = ubuntu ]; then
    if [ \( "$OS_VER"=="20.04" \) ]; then
      echo "The OS matches the requierements."
    else
      echo $"Newer version of the operating system is needed.\n"
      exit 1
  else
    echo "Wrong distro, try Ubuntu 20.04\n"
    exit 1
  fi
}

get_unsucked () {
  echo "Getting repos..."
  git clone https://git.suckless.org/dwm
  git clone https://git.suckless.org/st
  git clone https://git.suckless.org/dmenu
  echo "Downloaded!!"
}


installation (){
  sudo apt-get update \
  xargs sudo apt-get install < add-list \
  xargs sudo apt-get remove < remove-list
}

check_linux
echo "Call \`sudo reboot\` to complete the setup."
