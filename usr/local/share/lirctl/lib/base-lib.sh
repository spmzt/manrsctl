#!/bin/sh

OSKERNEL=$(uname -s)

to_lower() {
  echo $1 | tr '[:upper:]' '[:lower:]'
}

print_error() {
  local RED='\033[0;31m'
  local NC='\033[0m' # No Color
  printf "${RED}ERROR:\t$1${NC}\n"
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

# Get AS$1 replace it with $1
as_num_base_get() {
  echo $1 | tr -d 'AS'
}

usage() {
  cat <<EOF
lirctl(8) is an open-source utility for automating deployment and management of
LIRs.

Usage:
  lirctl command [args]

Available Commands:
  bgp    prepare and setup BGP configurations.
  cron   prepare and updates BGP filters.
  ipv6   provide IPv6 utilities (e.g random host address).

Use "lirctl -v|--version" for version information.
Use "lirctl command -h|--help" for more information about a command.

EOF
  exit 1
}
