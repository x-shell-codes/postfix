#!/bin/bash

########################################################################################################################
# Find Us                                                                                                              #
# Author: Mehmet ÖĞMEN                                                                                                 #
# Web   : https://x-shell.codes/scripts/postfix                                                                          #
# Email : mailto:postfix.script@x-shell.codes                                                                            #
# GitHub: https://github.com/x-shell-codes/postfix                                                                       #
########################################################################################################################
# Contact The Developer:                                                                                               #
# https://www.mehmetogmen.com.tr - mailto:www@mehmetogmen.com.tr                                                       #
########################################################################################################################

########################################################################################################################
# Constants                                                                                                            #
########################################################################################################################
NORMAL_LINE=$(tput sgr0)
RED_LINE=$(tput setaf 1)
YELLOW_LINE=$(tput setaf 3)
GREEN_LINE=$(tput setaf 2)
BLUE_LINE=$(tput setaf 4)
POWDER_BLUE_LINE=$(tput setaf 153)
BRIGHT_LINE=$(tput bold)
REVERSE_LINE=$(tput smso)
UNDER_LINE=$(tput smul)

########################################################################################################################
# Line Helper Functions                                                                                                #
########################################################################################################################
function ErrorLine() {
    echo "${RED_LINE}$1${NORMAL_LINE}"
}

function WarningLine() {
    echo "${YELLOW_LINE}$1${NORMAL_LINE}"
}

function SuccessLine() {
    echo "${GREEN_LINE}$1${NORMAL_LINE}"
}

function InfoLine() {
    echo "${BLUE_LINE}$1${NORMAL_LINE}"
}

########################################################################################################################
# Version                                                                                                              #
########################################################################################################################
function Version() {
  echo "Postfix version 1.0.0"
  echo
  echo "${BRIGHT_LINE}${UNDER_LINE}Find Us${NORMAL}"
  echo "${BRIGHT_LINE}Author${NORMAL}: Mehmet ÖĞMEN"
  echo "${BRIGHT_LINE}Web${NORMAL}   : https://x-shell.codes/scripts/postfix"
  echo "${BRIGHT_LINE}Email${NORMAL} : mailto:postfix.script@x-shell.codes"
  echo "${BRIGHT_LINE}GitHub${NORMAL}: https://github.com/x-shell-codes/postfix"
}

########################################################################################################################
# Help                                                                                                                 #
########################################################################################################################
function Help() {
  echo "Postfix install script."
  echo
  echo "Options:"
  echo "-d | --domain        Domain name (example.com)"
  echo "-h | --help          Display this help."
  echo "-V | --version       Print software version and exit."
  echo
  echo "For more details see https://github.com/x-shell-codes/postfix."
}

########################################################################################################################
# Arguments Parsing                                                                                                    #
########################################################################################################################
for i in "$@"; do
  case $i in
  -d=* | --domain=*)
    domain="${i#*=}"

    if [ -z "$domain" ]; then
      ErrorLine "Domain name is empty."
      exit
    fi

    shift
    ;;
  -h | --help)
    Help
    exit
    ;;
  -V | --version)
    Version
    exit
    ;;
  -* | --*)
    ErrorLine "Unexpected option: $1"
    echo
    echo "Help:"
    Help
    exit
    ;;
  esac
done

########################################################################################################################
# CheckRootUser Function                                                                                               #
########################################################################################################################
function CheckRootUser() {
  if [ "$(whoami)" != root ]; then
    ErrorLine "You need to run the script as user root or add sudo before command."
    exit 1
  fi
}

########################################################################################################################
# Main Program                                                                                                         #
########################################################################################################################
echo "${POWDER_BLUE_LINE}${BRIGHT_LINE}${REVERSE_LINE}POSTFIX INSTALLING${NORMAL_LINE}"

CheckRootUser

export DEBIAN_FRONTEND=noninteractive

if [ -z "$domain" ]; then
  ErrorLine "Domain name is empty."
  exit
fi

debconf-set-selections <<< "postfix postfix/mailname string www.local.$domain"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"

apt install -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --force-yes postfix
