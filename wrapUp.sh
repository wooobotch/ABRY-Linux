#!/bin/bash

set -Eeo pipefail

echo -e $"*****************************************\n
*** Auto-Bootstrapper & Resource Yoke ***\n
***        Guided Installation        ***\n
*****************************************\n"

#Checks for the right distro and version before starting the process
check_linux (){
  OS_ID=$(. /etc/os-release && echo "$ID")
  OS_VER=$(. /etc/os-release && echo "$VERSION_ID")

  if [ $OS_ID = ubuntu ]; then
    if [ \( "$OS_VER"=="20.04" \) ]; then
      echo "The OS matches the requierements."
    else
      echo $"Newer version of the operating system is needed.\n"
      exit 1
    fi
  else
    echo "Wrong distro, try Ubuntu 20.04\n"
    exit 1
  fi
}

#Puts dotfiles and other configuration files in their corresponding directories
dotfiles_mover () {
  echo "Moving configuration files..."
}

#Downloads suckless stuff from repo
get_unsucked () {
  echo "Getting repos..."
  cp repo-list $HOME/abry/repos
  cd $HOME/abry/repos
  for URL in $(xargs echo < repo-list); do
    REPO=$(echo $URL | rev | cut -d "/" -f 1 | rev)
    [ ! -d "$REPO" ] && git clone $URL
  done
  echo "Downloaded!!"
  cd -
}

#Calls make and make clean install
maker () {
  cd $1
  $(make) && $(sudo make clean install) && $(echo "$1 successfully installed") || $(echo "$1 installtion aborted")
  cd -
}


#General installation function
installation () {
  cd $HOME/ABRY-Ubuntu
  sudo apt-get update
  xargs sudo apt-get install -y --no-install-recommends < add-list
  xargs sudo apt-get remove < remove-list
  cd $HOME/abry/repos
  for DIREC in ./*; do
    [ -d "$(basename "$DIREC")" ] && maker "$(basename "$DIREC")"
  done
  cd -
}

main () {
  check_linux
  dotfiles_mover
  [ -d "$HOME/abry/repos" ] || mkdir -p $HOME/abry/repos
  get_unsucked
  installation

  echo "Call \`sudo reboot\` to complete the setup."
}


main
