#!/bin/sh

bgp_usage() {
    cat << EOF
Usage:
  lirctl bgp COMMAND

Available Commands:
    filters      generates the bogon filters, including as path lists, ipv6 prefix lists.
    full        generate full configuration (update + bgp configuration).

Use "lirctl -v|--version" for version information.
EOF
    exit 1
}

bgp_filters() {
    full_asp_list

    full_pfl_list
    echo
}
