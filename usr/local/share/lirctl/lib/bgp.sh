#!/bin/sh

# Generate neighbor configuration for specific AS number ($1), its description ($2),
# its maximum incoming prefixes ($3), its as-set and prefix-lists,
# and optionally its neighbors ($4), and update-source ($5)
neighbor_ds_bgp_get() {
  ASN="$(as_num_base_get $1)"
  echo "router bgp $MY_ASN
neighbor $1 peer-group
neighbor $1 description \"---------- $2 ----------\"
neighbor $1 remote-as $ASN
neighbor $1 send-community both
neighbor $1 capability dynamic"

  if [ -n "$5" ];
  then
    echo "neighbor $1 update-source $5"
  fi

  for neighbor in $4
  do
    echo "neighbor $neighbor peer-group $1"
  done

  echo "address-family ipv6 unicast
  neighbor $1 remove-private-AS
  neighbor $1 soft-reconfiguration inbound
  neighbor $1 route-map RTM_IMPORT_FROM_$1 in
  neighbor $1 route-map RTM_EXPORT_TO_$1 out
  neighbor $1 filter-list ASP_IMPORT_FROM_$1 in
  neighbor $1 prefix-list PFL_IMPORT_FROM_$1 in
  neighbor $1 prefix-list PFL_EXPORT_TO_$1 out
  neighbor $1 maximum-prefix-out $MY_MAX_PREFIX
  neighbor $1 maximum-prefix $3
  neighbor $1 activate
  exit
exit"
}

# Generate neighbor configuration for specific AS number ($1), its description ($2),
# and optionally its neighbors ($3), and update-source ($4)
neighbor_ds_rev_bgp_get() {
  ASN="$(as_num_base_get $1)"
  echo "router bgp $MY_ASN
neighbor $1 peer-group
neighbor $1 description \"---------- $2 ----------\"
neighbor $1 remote-as $ASN
neighbor $1 send-community both
neighbor $1 capability dynamic"

  if [ -n "$4" ];
  then
    echo "neighbor $1 update-source $4"
  fi

  for neighbor in $3
  do
    echo "neighbor $neighbor peer-group $1"
  done

  echo "address-family ipv6 unicast
  neighbor $1 remove-private-AS
  neighbor $1 soft-reconfiguration inbound
  neighbor $1 route-map RTM_IMPORT_FROM_$1 in
  neighbor $1 route-map RTM_EXPORT_TO_$1 out
  neighbor $1 prefix-list PFL_EXPORT_TO_$1 out
  neighbor $1 maximum-prefix-out $MY_MAX_PREFIX
  neighbor $1 activate
  exit
exit"
}

# Generate all of the peer configurations
neighbor_bgp_list() {
    ass_asn_yml_get | while read peer
    do
        neighbor_ds_bgp_get $peer "$(peer_description_yml_get $peer)" \
        "$(peer_max_prefix_yml_get $peer)" "$(neighbors_yml_get $peer)"
        echo
    done

    ass_rev_asn_yml_get | while read peer
    do
        neighbor_ds_rev_bgp_get $peer "$(peer_description_yml_get $peer)" \
        "$(neighbors_yml_get $peer)" "$(upd_src_yml_get $peer)"
        echo
    done
}