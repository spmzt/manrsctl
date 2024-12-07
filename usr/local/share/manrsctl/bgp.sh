#!/bin/sh

. /usr/local/share/manrsctl/common.sh

case "$1" in
    help|-h|--help)
        bgp_usage
        return
        ;;
    filters)
        bgp_filters
        return
        ;;
    peers)
        if [ "$2" = "only" ];
        then
            bgp_peers_only
        else
            bgp_peers
        fi
        return
        ;;
    network)
        bgp_network
        return
        ;;
    full)
        bgp_full
        return
        ;;
    *)
        bgp_usage
        ;;
esac
