#!/bin/sh

. /usr/local/share/manrsctl/common.sh

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