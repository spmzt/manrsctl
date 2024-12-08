#!/bin/sh

. /usr/local/share/manrsctl/common.sh
. /usr/local/share/manrsctl/lib/bgp-lib.sh

case "$1" in
    help|-h|--help)
        bgp_usage
        return
        ;;
    filters)
        if [ "$2" = "exec" ];
        then
            vtysh_frr_exec bgp_filters
        else
            bgp_filters
        fi
        return
        ;;
    peers)
        if [ "$2" = "only" ];
        then
            if [ "$3" = "exec" ];
            then
                vtysh_frr_exec bgp_peers_only
            else
                bgp_peers_only
            fi
        elif [ "$2" = "exec" ];
        then
            vtysh_frr_exec bgp_peers
        else
            bgp_peers
        fi
        return
        ;;
    network)
        if [ "$2" = "exec" ];
        then
            vtysh_frr_exec bgp_network
        else
            bgp_network
        fi
        return
        ;;
    full)
        if [ "$2" = "exec" ];
        then
            vtysh_frr_exec bgp_full
        else
            bgp_full
        fi
        return
        ;;
    *)
        bgp_usage
        ;;
esac
