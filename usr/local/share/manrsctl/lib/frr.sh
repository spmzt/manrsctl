#!/bin/sh

service_frr_check() {
	service frr status > /dev/null || exit 1
	which vtysh > /dev/null || exit 1
	vtysh -C > /dev/null || exit 1
}

# Pass your function to execute
vtysh_frr_exec() {
	local file="/tmp/vtysh.conf"
	service_frr_check
	$1 > $file
	vtysh -C -f $file || exit 1
	vty -f $file
}

get_prefix_lists_frr()
{
	service_frr_check
	vtysh -c 'show running-config bgpd no-header' | grep -E '^ipv6 prefix-list (EXPORT_IPV6_FROM|IMPORT_IPV6_FROM)' | cut -d' ' -f 3 | uniq
}

get_asn_lists_frr()
{
	check_frr
	vtysh -c 'show running-config bgpd no-header' | grep 'remote-as' | cut -d' ' -f 5 | uniq
}
