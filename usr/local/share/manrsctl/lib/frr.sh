#!/bin/sh

check_frr()
{
	service frr status > /dev/null || exit 1
	which vtysh > /dev/null || exit 1
	vtysh -C > /dev/null || exit 1
}

get_prefix_lists_frr()
{
	check_frr
	vtysh -c 'show running-config bgpd no-header' | grep -E '^ipv6 prefix-list (EXPORT_IPV6_FROM|IMPORT_IPV6_FROM)' | cut -d' ' -f 3 | uniq
}

get_asn_lists_frr()
{
	check_frr
	vtysh -c 'show running-config bgpd no-header' | grep 'remote-as' | cut -d' ' -f 5 | uniq
}
