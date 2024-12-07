#!/bin/sh

default_v4_bgp_get() {
	if [ -n "$(parse_yml get-value config.me.bgp.default-ipv4 2> /dev/null)" ];
	then
		if [ "True" = "$(parse_yml get-value config.me.bgp.default-ipv4)" ];
		then
			print_bgp "  bgp default ipv4-unicast"
		elif  [ "False" = "$(parse_yml get-value config.me.bgp.default-ipv4)" ];
		then
			print_bgp "  no bgp default ipv4-unicast"
		fi
	fi
}

default_bgp_get() {
	if [ -n "$(parse_yml get-value config.me.bgp.default-ipv6 2> /dev/null)" ];
	then
		if [ "True" = "$(parse_yml get-value config.me.bgp.default-ipv6)" ];
		then
			print_bgp "  bgp default ipv6-unicast"
		elif  [ "False" = "$(parse_yml get-value config.me.bgp.default-ipv6)" ];
		then
			print_bgp "  no bgp default ipv6-unicast"
		fi
	fi
}

suppress_pending_bgp_get() {
	if [ -n "$(parse_yml get-value config.me.bgp.suppress-fib-pending 2> /dev/null)" ];
	then
		if [ "True" = "$(parse_yml get-value config.me.bgp.suppress-fib-pending)" ];
		then
			print_bgp "  bgp suppress-fib-pending"
		elif  [ "False" = "$(parse_yml get-value config.me.bgp.suppress-fib-pending)" ];
		then
			print_bgp "  no bgp suppress-fib-pending"
		fi
	fi
}

enforce_first_as_bgp_get() {
	if [ -n "$(parse_yml get-value config.me.bgp.enforce-first-as 2> /dev/null)" ];
	then
		if [ "True" = "$(parse_yml get-value config.me.bgp.enforce-first-as)" ];
		then
			print_bgp "  bgp enforce-first-as"
		elif  [ "False" = "$(parse_yml get-value config.me.bgp.enforce-first-as)" ];
		then
			print_bgp "  no bgp enforce-first-as"
		fi
	fi
}

graceful_restart_as_bgp_get() {
	if [ -n "$(parse_yml get-value config.me.bgp.graceful-restart 2> /dev/null)" ];
	then
		if [ "True" = "$(parse_yml get-value config.me.bgp.graceful-restart)" ];
		then
			print_bgp "  bgp graceful-restart"
		elif  [ "False" = "$(parse_yml get-value config.me.bgp.graceful-restart)" ];
		then
			print_bgp "  no bgp graceful-restart"
		fi
	fi
}

net_import_check_as_bgp_get() {
	if [ -n "$(parse_yml get-value config.me.bgp.import-check 2> /dev/null)" ];
	then
		if [ "True" = "$(parse_yml get-value config.me.bgp.import-check)" ];
		then
			print_bgp "  bgp network import-check"
		elif  [ "False" = "$(parse_yml get-value config.me.bgp.import-check)" ];
		then
			print_bgp "  no bgp network import-check"
		fi
	fi
}

# Pass your neighbor AS ($1) to this function.
connected_check_bgp_get() {
	for peer_type in $(peer_type_yml_get)
	do
    if [ -n "$(parse_yml get-value config.$peer_type.$1.disable-connected-check 2> /dev/null)" ];
    then
      if [ "True" = "$(parse_yml get-value config.$peer_type.$1.disable-connected-check)" ];
      then
        print_bgp "  neighbor $1 disable-connected-check"
      elif  [ "False" = "$(parse_yml get-value config.$peer_type.$1.disable-connected-check)" ];
      then
        print_bgp "  no neighbor $1 disable-connected-check"
      fi
    fi
  done
}

# Pass your neighbor AS ($1) to this function.
ebgp_multihop_bgp_get() {
	for peer_type in $(peer_type_yml_get)
	do
    if [ -n "$(parse_yml get-value config.$peer_type.$1.ebgp-multihop 2> /dev/null)" ];
    then
        print_bgp "  neighbor $1 ebgp-multihop $(parse_yml get-value config.$peer_type.$1.ebgp-multihop)"
    fi
  done
}

# Pass your neighbor AS ($1) to this function.
addpath_tx_all_bgp_get() {
	for peer_type in $(peer_type_yml_get)
	do
    if [ -n "$(parse_yml get-value config.$peer_type.$1.addpath-tx-all-paths 2> /dev/null)" ];
    then
      if [ "True" = "$(parse_yml get-value config.$peer_type.$1.addpath-tx-all-paths)" ];
      then
        print_bgp "  neighbor $1 addpath-tx-all-paths"
      elif  [ "False" = "$(parse_yml get-value config.$peer_type.$1.addpath-tx-all-paths)" ];
      then
        print_bgp "  no neighbor $1 addpath-tx-all-paths"
      fi
    fi
  done
}

configure_bgp_get() {
  print_bgp "router bgp $MY_ASN"
  
  if [ -n "$BGP_RID" ];
  then
    print_bgp "  bgp router-id $BGP_RID"
  fi

  default_bgp_get
  default_v4_bgp_get
  suppress_pending_bgp_get
  enforce_first_as_bgp_get
  graceful_restart_as_bgp_get
  net_import_check_as_bgp_get

  print_bgp "  exit"
  print_bgp !
}

network_bgp_get() {
  print_bgp "router bgp $MY_ASN"
  myself_prefixes_yml_get | while read prefix
  do
      print_bgp "  network $prefix route-map RTM_EXPORT_FROM_AS$MY_ASN"
  done
  print_bgp "  exit"
}

# Generate neighbor configuration for specific AS number ($1), its description ($2),
# its maximum incoming prefixes ($3), its as-set and prefix-lists,
# and optionally its neighbors ($4), and update-source ($5)
neighbor_ds_bgp_get() {
  ASN="$(as_num_base_get $1)"
  print_bgp "router bgp $MY_ASN
  neighbor $1 peer-group
  neighbor $1 description ---------- $2 ----------
  neighbor $1 remote-as $ASN
  neighbor $1 send-community both
  neighbor $1 enforce-first-as
  neighbor $1 capability dynamic"

  if [ -n "$5" ];
  then
    print_bgp "  neighbor $1 update-source $5"
  fi

  connected_check_bgp_get $1
  ebgp_multihop_bgp_get $1
  addpath_tx_all_bgp_get $1

  for neighbor in $4
  do
    print_bgp "  neighbor $neighbor peer-group $1"
  done

  print_bgp "  address-family ipv6 unicast
    neighbor $1 remove-private-AS
    neighbor $1 soft-reconfiguration inbound
    neighbor $1 route-map RTM_IMPORT_FROM_$1 in
    neighbor $1 route-map RTM_EXPORT_TO_$1 out
    neighbor $1 filter-list ASP_IMPORT_FROM_$1 in
    neighbor $1 prefix-list PFL_IMPORT_FROM_$1 in
    neighbor $1 prefix-list PFL_EXPORT_FROM_AS$MY_ASN out
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
  print_bgp "router bgp $MY_ASN
  neighbor $1 peer-group
  neighbor $1 description ---------- $2 ----------
  neighbor $1 remote-as $ASN
  neighbor $1 send-community both
  neighbor $1 enforce-first-as
  neighbor $1 capability dynamic"

  if [ -n "$4" ];
  then
    print_bgp "  neighbor $1 update-source $4"
  fi

  connected_check_bgp_get $1
  ebgp_multihop_bgp_get $1

  for neighbor in $3
  do
    print_bgp "  neighbor $neighbor peer-group $1"
  done

  print_bgp "  address-family ipv6 unicast
    neighbor $1 remove-private-AS
    neighbor $1 soft-reconfiguration inbound
    neighbor $1 route-map RTM_IMPORT_FROM_$1 in
    neighbor $1 route-map RTM_EXPORT_TO_$1 out
    neighbor $1 prefix-list PFL_EXPORT_FROM_AS$MY_ASN out
    neighbor $1 maximum-prefix-out $MY_MAX_PREFIX
    neighbor $1 activate
    exit
  exit"
}

# Generate neighbor configuration for specific AS number ($1), its description ($2),
# and optionally its neighbors ($3), and update-source ($4)
neighbor_ixp_bgp_get() {
  ASN="$(as_num_base_get $1)"
  print_bgp "router bgp $MY_ASN
  neighbor $1 peer-group
  neighbor $1 description ---------- IXP: $2 ----------
  neighbor $1 remote-as $ASN
  neighbor $1 send-community both
  neighbor $1 capability dynamic
  no neighbor $1 enforce-first-as"

  if [ -n "$4" ];
  then
    print_bgp "  neighbor $1 update-source $4"
  fi

  for neighbor in $3
  do
    print_bgp "  neighbor $neighbor peer-group $1"
    print_bgp "  no neighbor $neighbor enforce-first-as"
  done

  print_bgp "  address-family ipv6 unicast
    neighbor $1 remove-private-AS
    neighbor $1 soft-reconfiguration inbound
    neighbor $1 route-map RTM_IMPORT_FROM_$1 in
    neighbor $1 route-map RTM_EXPORT_TO_$1 out
    neighbor $1 prefix-list PFL_EXPORT_FROM_AS$MY_ASN out
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
        print_bgp !
    done

    upstream_peer_type_yml_get | while read peer
    do
        neighbor_ds_rev_bgp_get $peer "$(peer_description_yml_get $peer)" \
        "$(neighbors_yml_get $peer)" "$(upd_src_yml_get $peer)"
        print_bgp !
    done

    ixp_peer_type_yml_get | while read peer
    do
        neighbor_ixp_bgp_get $peer "$(peer_description_yml_get $peer)" \
        "$(neighbors_yml_get $peer)" "$(upd_src_yml_get $peer)"
        print_bgp !
    done
}