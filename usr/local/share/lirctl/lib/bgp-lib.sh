#!/bin/sh

#    full        generate full configuration (update + bgp configuration).
bgp_usage() {
    cat << EOF
Usage:
  lirctl bgp COMMAND

Available Commands:
    filters      generates the bogon filters, including as path lists, ipv6 prefix lists.
    peers [only] generates the peer configurations.

Use "lirctl -v|--version" for version information.
EOF
    exit 1
}

bgp_filters() {
    # List of AS-Paths
    full_asp_list

    # List of prefix-lists
    full_pfl_list

    # List of Community Lists
    full_cml_list

    # List of route-maps
    full_rtm_list
}

bgp_peers() {
    bgp_filters

    # Configuration of peers
    neighbor_bgp_list
}

bgp_peers_only() {
    # Configuration of peers
    neighbor_bgp_list
}