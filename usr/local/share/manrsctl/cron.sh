#!/bin/sh

. /usr/local/share/manrsctl/common.sh
. /usr/local/share/manrsctl/lib/cron-lib.sh

case "$1" in
    help|-h|--help)
        cron_usage
        return
        ;;
    update)
        if [ "$2" = "exec"];
        then
            vtysh_frr_exec cron_update
        else
            cron_update
        fi
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
