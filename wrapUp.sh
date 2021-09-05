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
  else
    echo "Wrong distro, try Ubuntu 20.04\n"
    exit 1
  fi
}

#Downloads suckless stuff from repo
get_unsucked () {
  echo "Getting repos..."
  cd $HOME/repos
  git clone https://git.suckless.org/dwm
  git clone https://git.suckless.org/st
  git clone https://git.suckless.org/dmenu
  echo "Downloaded!!"
}

#Calls make and make clean install
maker () {
  cd $1
  make && make clean install && echo "$1 successfully installed" || echo "$1 installtion aborted"
  cd -
}


#General installation function
installation () {
  sudo apt-get update
  xargs sudo apt-get install < add-list
  xargs sudo apt-get remove < remove-list
  for dir in ./*; do
    [ -d "$(basename "$dir")" ] && maker "$(basename "$dir")"
  done
}

main () {
  check_linux
  [ -d "$HOME/abry/repos" ] || mkdir -p $HOME/abry/repos
  get_unsucked
  sudo installation

  echo "Call \`sudo reboot\` to complete the setup."
}


main
