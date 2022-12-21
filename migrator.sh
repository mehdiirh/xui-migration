#!/bin/bash

unset -v server
unset -v password

BGREEN='\033[1;32m'
BRED='\033[1;31m'
NC='\033[0m'

# check root
[[ $EUID -ne 0 ]] && echo -e "${BRED}Please run as root$NC" && exit 1;

while getopts s:u:p: flag
do
    case "${flag}" in
      s) server=${OPTARG};;
      u) username=${OPTARG};;
      *) echo "Invalid arg -$flag" && exit 1;;
    esac
done

[[ -z "$server" ]] && echo -n "Enter server name: " && read -r server;
[[ -z "$username" ]] && echo -n "Enter username: " && read -r username;

if (x-ui --help &> /dev/null )
then
  echo -e "${BGREEN}X-UI is already installed$NC"
else
  echo "Installing x-ui..."
  if ! (bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh))
  then
    echo -e "${BRED}Error in installing x-ui$NC" && exit 1;
  else
    echo -e "${BGREEN}X-UI successfully installed$NC"
  fi
fi

echo "Connecting to \"${server}\" with username \"$username\"..."

echo "Copying database..."
if (scp "${username}"@"${server}":/etc/x-ui/x-ui.db /etc/x-ui/x-ui.db)
then
  echo -e "${BGREEN}Successfully copied database from $server $NC"
else
  echo -e "${BRED}Error while trying to connect to $server"
fi

unset -v ssl_confirm;
echo -n "Do you want to import SSL certs as well ? [y/n]: ";
while [[ ! "$ssl_confirm" = "y" ]] || [[ ! "$ssl_confirm" = "n" ]]; do
  read -r ssl_confirm
  case $ssl_confirm in
    y) ssl_confirm=true && break;;
    n) echo "Ignoring ssl" && ssl_confirm=false&& break;;
    *) echo "Options are [y/n]";;
  esac
done

if [[ $ssl_confirm = true ]]
then
  echo -n "Enter ssl path: " && read -r ssl_path && echo -e "SSL path: $BRED$ssl_path$NC";

  echo "Copying SSL certs..."
  mkdir -p "${ssl_path}"

  if (scp -r "${username}"@"${server}":"${ssl_path}"/* "${ssl_path}")
  then
    echo -e "${BGREEN}Successfully copied SSL certs from $server $NC"
  else
    echo -e "${BRED}Error while trying to connect to $server"
  fi
fi

echo "Restarting x-ui..."
x-ui restart

echo -e "${BGREEN}Done$NC"
