#!/bin/sh

rpki_usage()
{
    cat << EOF
Usage:
  manrsctl rpki COMMAND

Available Commands:
    servers		Configuration of your RPKI Servers.

Use "manrsctl -v|--version" for version information.
EOF
    exit 1
}

rpki_servers()
{
    servers_rpki_get
}