#!/bin/sh

ipv6_usage()
{
    cat << EOF
Usage:
  lirctl ipv6 COMMAND

Available Commands:
    rand		Generate IPv6 host address based on prefix provided by arguments.

Use "lirctl -v|--version" for version information.
EOF
    exit 1
}

ipv6_rand()
{
    openssl rand -hex 8 | sed "s/.\{4\}/&:/g; s/:\$//"
}