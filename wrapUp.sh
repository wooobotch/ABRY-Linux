#!/bin/bash

set -Eeo pipefail

echo -e $"*****************************************\n
*** Auto-Bootstrapper & Resource Yoke ***\n
***        Guided Installation        ***\n
*****************************************\n"

#Checks for the right distro and version before starting the process
check_linux (){
  echo -e "\aChecking for distro and version:"
  OS_ID=$(. /etc/os-release && echo "$ID")

  if [ $OS_ID != "debian" ]; then
    echo "Wrong distro, try any Debian version."
    exit 1
  fi
}

apt_setup (){
  mv /etc/apt/apt.conf /etc/apt/apt.conf.old
  cp apt.conf /etc/apt/

  #mv /etc/apt/sources.list /etc/apt/sources.list.old
  #cp sources.list /etc/apt/

  #apt-get dist-upgrade

  echo "You may want to reboot now."

}


#Puts dotfiles and other configuration files in their corresponding directories
dotfiles_mover () {
  echo -e "\aMoving configuration files..." && sleep 1s
  #cp -r  $1/dotfiles/. $1/..
  cp keyboard /etc/default/keyboard
  cp ./dotfiles/xsessionrc /home/$1/.xsessionrc
  cp ./dotfiles/xinitrc /home/$1/.xinitrc
}

#Downloads suckless stuff from repo
get_unsucked () {
  echo -e "\aGetting repos..." && sleep 1s
  [ -d "$1/../abry/repos" ] || mkdir -p $1/../abry/repos
  cp repo-list $1/../abry/repos
  cd $1/../abry/repos
  for URL in $(xargs echo < repo-list); do
    REPO=$(echo $URL | rev | cut -d "/" -f 1 | rev)
    [ ! -d "$REPO" ] && git clone $URL
  done
  rm $1/../abry/repo-list
  cd -
  echo "The repos listed were downloaded!!" && sleep 1s
}

#Calls make and make clean install
maker () {
  echo -e "\aMaking $1!" && sleep 1s
  cd $1
  make || echo "Couldn't 'make'"
  sudo make clean install || echo "$1 installtion aborted"
  cd -
}

#General installation function
installation () {
  echo -e "\aPackage and repositories installation:" && sleep 1s
  cd $1
  sudo apt-get update
  xargs sudo apt-get install -y < add-list
  cd $1/../abry/repos
  for DIREC in $(xargs echo < repo-list); do
    [ -d "$(basename "$DIREC")" ] && maker "$(basename "$DIREC")"
  done
  cd -
}

#Uninstalation and obsolete package removal
clean_up (){
  echo -e "\aRevoming unnecesary reminders..." && sleep 1s
  cd $1
  xargs sudo apt-get remove < remove-list
  sudo apt-get autoremove
}

#Main function, it calls everything else
main () {
  check_linux
  apt-setup
  get_unsucked $1
  dotfiles_mover abry
  installation $1
  clean_up $1

  echo -e "Call \`sudo reboot\` to complete the setup.\n"
}

#Here starts it all
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
main $SCRIPTPATH
