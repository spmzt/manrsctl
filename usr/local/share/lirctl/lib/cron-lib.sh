#!/bin/sh

cron_usage()
{
    cat << EOF
Usage:
  lirctl cron COMMAND

Available Commands:
    update		only updates the filters, including as path lists, ipv6 prefix lists, route-maps.
    bogon       only updates the bogon filters, including as path lists, ipv6 prefix lists.
    full        generate full configuration (update + bgp configuration).

Use "lirctl -v|--version" for version information.
EOF
    exit 1
}

cron_bogon()
{
    bogon_asp_list
    bogon_pfl_list
}

cron_update()
{
    # Should be first due to value validation
    myself_out_pfl_get $HAVE_DOWNSTREAM
    echo 

    cron_bogon

    get_asn_with_downstream_lists | while read peer
    do
        ds_in_pfl_get $peer
        echo
        in_ds_asp_get $peer
        echo
    done
    echo
        
    get_asn_without_downstream_lists | while read peer
    do
        nods_in_pfl_get $peer
        echo
        in_nods_asp_get $peer
        echo
    done
    echo

    get_asn_lists | while read peer
    do
        in_rtm_get $peer "$(get_peer_upstream_bool $peer)"
        echo
        out_rtm_get $peer
        echo
    done
    echo
}

cron_full()
{
    cron_update
    get_asn_lists | while read peer
    do
        bgp_neighbor_peergroup_v6_create $peer $MAX_PREFIX "$(get_peer_upstream_bool $peer)"
        echo
    done
}