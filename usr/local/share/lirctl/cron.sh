#!/bin/sh

. /usr/local/share/lirctl/common.sh

case "$1" in
help|-h|--help)
    cron_usage
    ;;
esac

if [ "$1" = "update" ]
then
    cron_update
elif [ "$1" = "bogon" ]
then
	cron_bogon
elif [ "$1" = "full" ]
then
	cron_full
else
    cron_usage
fi