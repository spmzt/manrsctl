#!/bin/sh

. /usr/local/share/manrsctl/common.sh

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
    full)
        cron_full
        return
        ;;
    *)
        cron_usage
        ;;
esac
