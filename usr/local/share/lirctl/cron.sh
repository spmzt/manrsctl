#!/bin/sh

. /usr/local/share/lirctl/common.sh

get_asn_with_downstream_lists | while read peer
do
	in_ds_v6_gen $peer
	in_ds_aspath_gen $peer
done
	
get_asn_without_downstream_lists | while read peer
do
	in_nods_v6_gen $peer
	in_nods_aspath_gen $peer
done

