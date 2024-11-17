#!/bin/sh

# Generate import prefix list from $1 AS with $2 as-set
in_ds_v6_gen()
{
	bgpq3 -m 48 -A6l IMPORT_IPV6_FROM_AS$1 $2
}

# Generate import as path list from $1 AS with $2 as-set
in_ds_aspath_gen()
{
	bgpq3 -Dl IMPORT_ASN_FROM_AS$1 -f $1 $2
}

# Generate import prefix list from $1 AS without downstream
in_nods_v6_gen()
{
	bgpq3 -m 48 -A6l IMPORT_IPV6_FROM_AS$1 AS$1
}

# Generate import as path list from $1 AS with $2 as-set
in_nods_aspath_gen()
{
	echo "no bgp as-path access-list IMPORT_ASN_FROM_AS$1"
	echo "bgp as-path access-list IMPORT_ASN_FROM_AS$1 deny .*"
}

# Generate export prefix list from my AS with downstream
out_ds_v6_gen()
{
	bgpq3 -Dl EXPORT_IPV6_FROM_AS$MY_ASN -f $MY_ASN $MY_AS_SET
}

# Generate import prefix list from my AS without downstream
out_nods_v6_gen()
{
	bgpq3 -m 48 -A6l IMPORT_IPV6_FROM_AS$MY_ASN AS$MY_ASN
}

# Generate prefix list that matches with any ipv6
any_ipv6_gen()
{
	echo "
ipv6 prefix-list ANY_IPV6 description ALL IPv6 ranges
ipv6 prefix-list ANY_IPV6 seq 10 permit any
"
}

# Generate as path list that matches with any asn
any_aspath_gen()
{
	echo "bgp as-path access-list ANY_ASN permit .*"
}

# Generate bogon ASNs as path list
bogon_aspath_get()
{
	echo "
bgp as-path access-list BOGON_ASN seq 5 deny _0_
bgp as-path access-list BOGON_ASN seq 10 deny _23456_
bgp as-path access-list BOGON_ASN seq 15 deny _6449[6-9]_
bgp as-path access-list BOGON_ASN seq 20 deny _64[5-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 25 deny _6[5-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 30 deny _[7-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 35 deny _1[0-2][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 40 deny _130[0-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 45 deny _1310[0-6][0-9]_
bgp as-path access-list BOGON_ASN seq 50 deny _13107[0-1]_
bgp as-path access-list BOGON_ASN seq 55 deny _45875[2-9]_
bgp as-path access-list BOGON_ASN seq 60 deny _4587[6-9][0-9]_
bgp as-path access-list BOGON_ASN seq 65 deny _458[8-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 70 deny _459[0-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 75 deny _4[6-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 80 deny _[5-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 85 deny _[0-9][0-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 90 deny _[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 95 deny _[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 100 deny _[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 105 permit .*
"
}

bogon_rev_aspath_get()
{
	echo "
bgp as-path access-list BOGON_REV_ASN seq 5 permit _0_
bgp as-path access-list BOGON_REV_ASN seq 10 permit _23456_
bgp as-path access-list BOGON_REV_ASN seq 15 permit _6449[6-9]_
bgp as-path access-list BOGON_REV_ASN seq 20 permit _64[5-9][0-9][0-9]_
bgp as-path access-list BOGON_REV_ASN seq 25 permit _6[5-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_REV_ASN seq 30 permit _[7-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_REV_ASN seq 35 permit _1[0-2][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_REV_ASN seq 40 permit _130[0-9][0-9][0-9]_
bgp as-path access-list BOGON_REV_ASN seq 45 permit _1310[0-6][0-9]_
bgp as-path access-list BOGON_REV_ASN seq 50 permit _13107[0-1]_
bgp as-path access-list BOGON_REV_ASN seq 55 permit _45875[2-9]_
bgp as-path access-list BOGON_REV_ASN seq 60 permit _4587[6-9][0-9]_
bgp as-path access-list BOGON_REV_ASN seq 65 permit _458[8-9][0-9][0-9]_
bgp as-path access-list BOGON_REV_ASN seq 70 permit _459[0-9][0-9][0-9]_
bgp as-path access-list BOGON_REV_ASN seq 75 permit _4[6-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_REV_ASN seq 80 permit _[5-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_REV_ASN seq 85 permit _[0-9][0-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_REV_ASN seq 90 permit _[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_REV_ASN seq 95 permit _[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_REV_ASN seq 100 permit _[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_REV_ASN seq 105 deny .*
"
}

bogon_prefixlist_v4_get()
{
	echo "
ip prefix-list BOGON_v4 deny 0.0.0.0/8 le 32
ip prefix-list BOGON_v4 deny 10.0.0.0/8 le 32
ip prefix-list BOGON_v4 deny 100.64.0.0/10 le 32
ip prefix-list BOGON_v4 deny 127.0.0.0/8 le 32
ip prefix-list BOGON_v4 deny 169.254.0.0/16 le 32
ip prefix-list BOGON_v4 deny 172.16.0.0/12 le 32
ip prefix-list BOGON_v4 deny 192.0.2.0/24 le 32
ip prefix-list BOGON_v4 deny 192.88.99.0/24 le 32
ip prefix-list BOGON_v4 deny 192.168.0.0/16 le 32
ip prefix-list BOGON_v4 deny 198.18.0.0/15 le 32
ip prefix-list BOGON_v4 deny 198.51.100.0/24 le 32
ip prefix-list BOGON_v4 deny 203.0.113.0/24 le 32
ip prefix-list BOGON_v4 deny 224.0.0.0/4 le 32
ip prefix-list BOGON_v4 deny 240.0.0.0/4 le 32
"
}

bogon_prefixlist_v6_get()
{
	echo "
ipv6 prefix-list BOGON_v6 deny ::/8 le 128
ipv6 prefix-list BOGON_v6 deny 100::/64 le 128
ipv6 prefix-list BOGON_v6 deny 2001:2::/48 le 128
ipv6 prefix-list BOGON_v6 deny 2001:10::/28 le 128
ipv6 prefix-list BOGON_v6 deny 2001:db8::/32 le 128
ipv6 prefix-list BOGON_v6 deny 3fff::/20 le 128
ipv6 prefix-list BOGON_v6 deny 2002::/16 le 128
ipv6 prefix-list BOGON_v6 deny 3ffe::/16 le 128
ipv6 prefix-list BOGON_v6 deny 5f00::/16 le 128
ipv6 prefix-list BOGON_v6 deny fc00::/7 le 128
ipv6 prefix-list BOGON_v6 deny fe80::/10 le 128
ipv6 prefix-list BOGON_v6 deny fec0::/10 le 128
ipv6 prefix-list BOGON_v6 deny ff00::/8 le 128
"
}

# Generate import route-map from $1 based on being our upstream or not $2
in_rtm_v6_gen()
{
	if [ "$2" = "True" ]
	then
		UPSTREAM_ASN_LINE="ANY_ASN"
		UPSTREAM_IPV6_LINE="ANY_IPV6"
	elif [ "$2" = "False" ]
	then
		UPSTREAM_ASN_LINE="IMPORT_ASN_FROM_AS$1"
		UPSTREAM_IPV6_LINE="IMPORT_IPV6_FROM_AS$1"
	else
		echo "lirctl -> Error: Upstream values in peer $1 should be yes or no"
		exit 1
	fi

	echo "
route-map IMPORT_RTMV6_FROM_AS$1 deny 1
 description Drop Invalid RPKI
 match rpki invalid
exit
!
route-map IMPORT_RTMV6_FROM_AS$1 deny 2
 description Drop Bogon Prefixlist
 match ipv6 address prefix-list BOGON_v6
exit
!
route-map IMPORT_RTMV6_FROM_AS$1 deny 3
 description Drop Bogon AS Path
 match as-path BOGON_REV_ASN
exit
!
route-map IMPORT_RTMV6_FROM_AS$1 permit 10
 description Import any valid RPKI from $1
 match rpki valid
 match ipv6 address prefix-list $UPSTREAM_IPV6_LINE
 match as-path $UPSTREAM_ASN_LINE
 match as-path BOGON_ASN
 set local-preference 30
exit
!
route-map IMPORT_RTMV6_FROM_AS$1 permit 20
 description Import any prefix that not found in RPKI db from $1 with lower pref
 match rpki notfound
 match ipv6 address prefix-list $UPSTREAM_IPV6_LINE
 match as-path $UPSTREAM_ASN_LINE
 match as-path BOGON_ASN
 set local-preference 20
exit
!
route-map IMPORT_RTMV6_FROM_AS$1 deny 99
 description Reject any prefix from $1
 match ipv6 address prefix-list ANY_IPV6
exit
"
}

# Generate export route-map to $1
out_rtm_v6_gen()
{
	echo "
route-map EXPORT_RTMV6_TO_AS$1 deny 1
 description Drop Invalid RPKI
 match rpki invalid
exit
!
route-map EXPORT_RTMV6_TO_AS$1 deny 2
 description Drop Bogon Prefixlist
 match ipv6 address prefix-list BOGON_v6
exit
!
route-map EXPORT_RTMV6_TO_AS$1 deny 3
 description Drop Bogon AS Path
 match as-path BOGON_REV_ASN
exit
!
route-map EXPORT_RTMV6_TO_AS$1 permit 10
 description Export netwroks with valid RPKI
 match ipv6 address prefix-list EXPORT_IPV6_FROM_AS$1
 match ipv6 address prefix-list EXPORT_IPV6_NETWORK
 match rpki valid
exit
!
route-map EXPORT_RTMV6_TO_AS$1 deny 99
 description Export netwroks with specific BGP attributes
 match ipv6 address prefix-list ANY_IPV6
exit
"
}

# Generate export ipv6 prefix list from my ASN based on DOWNSTREAM value ($1) 
out_my_v6_gen()
{
	if [ "$1" = "True" ]
	then
		out_ds_v6_gen
	elif [ "$1" = "False" ]
	then
		out_nods_v6_gen
	else
		echo "lirctl -> Error: You can set your downstream value to only yes or no"
		exit 1
	fi
}
