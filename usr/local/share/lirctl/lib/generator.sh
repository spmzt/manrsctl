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
	echo "no ip as-path access-list IMPORT_ASN_FROM_AS$1"
	echo "ip as-path access-list IMPORT_ASN_FROM_AS$1 deny .*"
}
