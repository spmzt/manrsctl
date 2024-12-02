#!/bin/sh

# Generate neighbor configuration for $1 based on being our upstream or not $2
bgp_neighbor_peergroup_v6_create()
{
  if [ "$3" = "True" ]
	then
		UPSTREAM_ASN_LINE="ASP_ANY"
		UPSTREAM_IPV6_LINE="PFL_ANY"
	elif [ "$3" = "False" ]
	then
		UPSTREAM_ASN_LINE="IMPORT_ASN_FROM_AS$1"
		UPSTREAM_IPV6_LINE="IMPORT_IPV6_FROM_AS$1"
	else
		echo "lirctl -> Error: Upstream values in peer $1 should be yes or no"
		exit 1
	fi

    echo "router bgp $MY_ASN
neighbor AS$1 peer-group
neighbor AS$1 remote-as $1
neighbor AS$1 send-community both
neighbor AS$1 capability dynamic
address-family ipv6 unicast
  neighbor AS$1 remove-private-AS
  neighbor AS$1 soft-reconfiguration inbound
  neighbor AS$1 route-map IMPORT_RTMV6_FROM_AS$1 in
  neighbor AS$1 route-map EXPORT_RTMV6_TO_AS$1 out
  neighbor AS$1 filter-list $UPSTREAM_ASN_LINE in
  neighbor AS$1 prefix-list $UPSTREAM_IPV6_LINE in
  neighbor AS$1 prefix-list EXPORT_IPV6_TO_AS$1 out
  neighbor AS$1 maximum-prefix-out $2
  neighbor AS$1 activate
  exit
exit"
}
