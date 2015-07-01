#!/bin/bash

URL="https://github.com/prologic/autodock-paas/blob/master/docker-compose.yml >>"
FILE="docker-compose.yml"

function die () {
    echo "${1}"
    exit 1
}

function ask() {
    # http://djm.me/ask
    while true; do
 
        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi
 
        # Ask the question - use /dev/tty in case stdin is redirected from somewhere else
        read -p "$1 [$prompt] " REPLY </dev/tty
 
        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi
 
        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac
 
    done
}

command -v docker &> /dev/null || die "You must have Docker installed"
command -v docker-compose &> /dev/null || die "You must also have Docker Compose installed"


if [ -f $FILE ]; then
  echo "A $FILE already exists."
  echo "We will append to the existing file."
  ask "Continue?" Y || die "Aborted"
fi

echo "Installing autodock-paas ..."

curl -sSL -o - $URL >> $FILE

docker-compose up -d autodock
docker-compose up -d autodock-hipache
