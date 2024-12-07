#!/bin/sh

rpki_usage()
{
    cat << EOF
Usage:
  lirctl rpki COMMAND

Available Commands:
    servers		Configuration of your RPKI Servers.

Use "lirctl -v|--version" for version information.
EOF
    exit 1
}

rpki_servers()
{
    servers_rpki_get
}