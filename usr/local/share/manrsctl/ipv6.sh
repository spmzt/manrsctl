#!/bin/sh

. /usr/local/share/manrsctl/common.sh

case "$1" in
help|-h|--help)
    ipv6_usage
    ;;
esac

if [ "$1" = "rand" ]
then
    ipv6_rand
else
    ipv6_usage
fi