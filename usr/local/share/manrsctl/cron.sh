#!/bin/sh

. /usr/local/share/manrsctl/common.sh
. /usr/local/share/manrsctl/lib/cron-lib.sh

case "$1" in
    help|-h|--help)
        cron_usage
        return
        ;;
    update)
        cron_update
        return
        ;;
    bogon)
        cron_bogon
        return
        ;;
    edrop)
        cron_edrop
        return
        ;;
    *)
        cron_usage
        ;;
esac
