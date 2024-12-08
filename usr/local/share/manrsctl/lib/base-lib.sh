#!/bin/sh

OSKERNEL=$(uname -s)

# Colors
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
NC='\033[0m' # No Color

to_lower() {
  echo $1 | tr '[:upper:]' '[:lower:]'
}

print_error() {
  printf "${RED}ERROR:\t$1${NC}\n"
}

print_bgp() {
  printf "${GREEN}$1${NC}\n"
}

number_validator() {
  case $1 in
  '' | *[!0-9]*)
    false
    ;;
  *)
    true
    ;;
  esac
}

force_run_as_root() {
  uid=$(id -u)
  if [ $uid != 0 ]; then
    print_error "Please run as \"root\" and try again."
    exit 1
  fi
}

fetch_edrop() {
  local url="https://www.spamhaus.org/drop/asndrop.json"
  if [ "$OSKERNEL" = "FreeBSD" ];
  then
    fetch -q -o - $url
  elif [ "$OSKERNEL" = "Linux" ];
  then
    curl -q --no-progress-meter $url
  else
    curl -q --no-progress-meter $url
  fi
}

edrop_jq_get() {
  fetch_edrop | jq .asn | grep -E '^([1-9]){1}([0-9]){0,9}$'
}

# Get AS$1 replace it with $1
as_num_base_get() {
  echo $1 | tr -d 'AS'
}

usage() {
  cat <<EOF
manrsctl(8) is an open-source utility for automating deployment and management of
MANRS Requirements.

Usage:
  manrsctl command [args]

Available Commands:
  bgp    prepare and setup BGP configurations.
  cron   prepare and updates BGP filters.
  ipv6   provide IPv6 utilities (e.g random host address).
  rpki   provide rpki configurations.

Use "manrsctl -v|--version" for version information.
Use "manrsctl command -h|--help" for more information about a command.

EOF
  exit 1
}
