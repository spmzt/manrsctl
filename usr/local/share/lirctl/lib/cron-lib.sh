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
    myself_out_pfl_get
    echo

    cron_bogon

    ass_asn_yml_get | while read peer
    do
        ds_in_pfl_get $peer
        echo
        ds_in_asp_get $peer
        echo
    done
    echo
        
    ass_rev_asn_yml_get | while read peer
    do
        nods_in_pfl_get $peer
        echo
        nods_in_asp_get $peer
        echo
    done
    echo

    asn_yml_get | while read peer
    do
        in_rtm_get $peer
        echo
        out_rtm_get $peer
        echo
    done
    echo
}

cron_full()
{
    cron_update
    neighbor_bgp_list
}