#!/bin/sh

#    full        generate full configuration (update + bgp configuration).
bgp_usage() {
    cat << EOF
Usage:
  manrsctl bgp COMMAND

Available Commands:
    filters      Generates bogon filters, including as path lists, ipv6 prefix lists.
    peers [only] Generates peer configurations.
    network      Generates network advertisement configurations.

Use "manrsctl -v|--version" for version information.
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

    # RPKI
    servers_rpki_get

    # List of route-maps
    full_rtm_list
}

bgp_peers() {
    bgp_filters

    # Configuration of BGP
    configure_bgp_get

    # Configuration of peers
    neighbor_bgp_list
}

bgp_peers_only() {
    # Configuration of peers
    neighbor_bgp_list
}

bgp_network() {
    # Route-map configuration of my asn prefixes
    my_out_rtm_get

    # Configuration of network commands
    network_bgp_get
}