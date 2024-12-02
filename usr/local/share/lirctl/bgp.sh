#!/bin/sh

. /usr/local/share/lirctl/common.sh

case "$1" in
help|-h|--help)
    bgp_usage
    ;;
esac

if [ "$1" = "filters" ]
then
    bgp_filters
elif [ "$1" = "bogon" ]
then
	cron_bogon
else
    bgp_usage
fi