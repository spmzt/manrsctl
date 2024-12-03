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
elif [ "$1" = "peers" ]
then
    if [ "$2" = "only" ];
    then
        bgp_peers_only
    else
        bgp_peers
    fi
else
    bgp_usage
fi
