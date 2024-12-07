#!/bin/sh

. /usr/local/share/lirctl/common.sh

case "$1" in
    help|-h|--help)
        rpki_usage
        return
        ;;
    servers)
        rpki_servers
        return
        ;;
    *)
        rpki_usage
        ;;
esac