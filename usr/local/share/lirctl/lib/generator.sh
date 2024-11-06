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
route-map IMPORT_RTMV6_FROM_AS$1 permit 10
 description Import any valid RPKI from $1
 match rpki valid
 match ipv6 address prefix-list $UPSTREAM_IPV6_LINE
 match as-path $UPSTREAM_ASN_LINE
 match as-path BOGON_ASN
 set local-preference 30
exit
!
route-map IMPORT_RTMV6_FROM_AS$1 permit 15
 description Import any prefix that not found in RPKI db from $1 with lower pref
 match rpki notfound
 match ipv6 address prefix-list $UPSTREAM_IPV6_LINE
 match as-path $UPSTREAM_ASN_LINE
 match as-path BOGON_ASN
 set local-preference 20
exit
!
route-map IMPORT_RTMV6_FROM_AS$1 deny 20
 description Reject any prefix that is not valid in RPKI db from $1
 match rpki invalid
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
