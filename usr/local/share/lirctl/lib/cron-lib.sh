#!/bin/sh

cron_usage()
{
    cat << EOF
Usage:
  lirctl cron COMMAND

Available Commands:
    update		only updates the filters, including as path lists, ipv6 prefix lists, route-maps.
    full        generate full configuration (update + bgp configuration).

Use "lirctl -v|--version" for version information.
EOF
    exit 1
}

cron_update()
{
    # Should be first due to value validation
    out_my_v6_gen $HAVE_DOWNSTREAM
    echo 

    echo "ipv6 prefix-list EXPORT_IPV6_NETWORK description my IPv6 prefixes that we want to advertise"
    seq_num=10
    get_my_prefixes | while read prefix
    do
        echo "ipv6 prefix-list EXPORT_IPV6_NETWORK seq $seq_num permit $prefix"
        seq_num="$(expr $seq_num + 10)"
    done
    echo

    any_ipv6_gen
    echo

    any_aspath_gen
    echo

    bogon_aspath_get
    echo

    get_asn_with_downstream_lists | while read peer
    do
        in_ds_v6_gen $peer
        echo
        in_ds_aspath_gen $peer
        echo
    done
    echo
        
    get_asn_without_downstream_lists | while read peer
    do
        in_nods_v6_gen $peer
        echo
        in_nods_aspath_gen $peer
        echo
    done
    echo

    get_asn_lists | while read peer
    do
        in_rtm_v6_gen $peer "$(get_peer_upstream_bool $peer)"
        echo
        out_rtm_v6_gen $peer
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