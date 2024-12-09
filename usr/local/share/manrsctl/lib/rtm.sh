#!/bin/sh

# Drop invalid
# Note: This route-map must be called by other route-maps
invalid_rtm_get() {
  echo "route-map RTM_INVALID_DENY deny 1
 description Drop Invalid RPKI
 match rpki invalid
exit
!
route-map RTM_INVALID_DENY deny 2
 description Drop IPv6 Bogon Prefixlist
 match ipv6 address prefix-list PFL_BOGON
exit
!
route-map RTM_INVALID_DENY deny 3
 description Drop IPv4 Bogon Prefixlist
 match ip address prefix-list PFL_V4_BOGON
exit
!
route-map RTM_INVALID_DENY deny 4
 description Drop Bogon AS Path
 match as-path ASP_REV_BOGON
exit
!
route-map RTM_INVALID_DENY deny 5
 description Drop Edrop AS Path
 match as-path ASP_REV_EDROP
exit
!
route-map RTM_INVALID_DENY permit 99
 description call by other route-maps, permit anything
exit"
}

# Set no-export route-map
no_export_rtm_get() {
  echo "route-map RTM_NO_EXPORT permit 10
 set community additive no-export
exit
!
route-map RTM_NO_EXPORT permit 20
exit"
}

# Set blackhole route-map with local-preference 10, no-export, and next-hop 100::1
# Note: This route-map must be called by other route-maps
blackhole_rtm_get() {
  echo "route-map RTM_BLACKHOLE permit 10
 description blackhole, up-pref and ensure it cannot escape this AS
 set ipv6 next-hop global 100::1
 set local-preference 10
 set community additive no-export
exit
!
route-map RTM_BLACKHOLE permit 20
exit"
}

# Set local-pref as requested
# Note: This route-map must be called by other route-maps
prefmod_rtm_get() {
  echo "route-map RTM_PREFMOD permit 10
 match large-community CMS_PREFMOD_100
 set local-preference 100
exit
!
route-map RTM_PREFMOD permit 20
 match large-community CMS_PREFMOD_200
 set local-preference 200
exit
!
route-map RTM_PREFMOD permit 30
 match large-community CMS_PREFMOD_300
 set local-preference 300
exit
!
route-map RTM_PREFMOD permit 40
 match large-community CMS_PREFMOD_400
 set local-preference 400
exit
!
route-map RTM_PREFMOD permit 50
exit"
}

# Community actions to take on receipt of route.
# Note: This route-map must be called by other route-maps
cml_in_rtm_get() {
  echo "route-map RTM_CML_IN permit 10
 description check for blackholing, no point continuing if it matches.
 match large-community CMS_BLACKHOLE
 call RTM_BLACKHOLE
exit
!
route-map RTM_CML_IN permit 20
 match large-community CMS_NO_EXPORT
 call RTM_NO_EXPORT
 on-match next
exit
!
route-map RTM_CML_IN permit 30
 match large-community CME_PREFMOD_RANGE
 call RTM_PREFMOD
exit
!
route-map RTM_CML_IN permit 40
exit"
}

# Community actions to take when advertising a route.
# These are filtering route-maps,

# Deny routes to upstream with downstream-only or ixp-only or peers-only set.
# Note: This route-map must be called by other route-maps
flt_cml_ups_out_rtm_get() {
  echo "route-map RTM_CML_FLT_TO_UPS deny 10
 match large-community CMS_DS_ONLY
exit
!
route-map RTM_CML_FLT_TO_UPS deny 20
 match large-community CMS_IXP_ONLY
exit
!
route-map RTM_CML_FLT_TO_UPS deny 30
 match large-community CMS_PEERS_ONLY
exit
!
route-map RTM_CML_FLT_TO_UPS permit 40
 match large-community CMS_UPS_NO_EXPORT
 call RTM_NO_EXPORT
 on-match next
exit
!
route-map RTM_CML_FLT_TO_UPS permit 99
exit"
}

# Deny routes to customers with upstream-only or ixp-only or peers-only set.
# Note: This route-map must be called by other route-maps
flt_cml_ds_out_rtm_get() {
  echo "route-map RTM_CML_FLT_TO_DS deny 10
 match large-community CMS_UPS_ONLY
exit
!
route-map RTM_CML_FLT_TO_DS deny 20
 match large-community CMS_IXP_ONLY
exit
!
route-map RTM_CML_FLT_TO_DS deny 30
 match large-community CMS_PEERS_ONLY
exit
!
route-map RTM_CML_FLT_TO_DS permit 40
 match large-community CMS_DS_NO_EXPORT
 call RTM_NO_EXPORT
 on-match next
exit
!
route-map RTM_CML_FLT_TO_DS permit 99
exit"
}

# Deny routes to IXPs with upstream-only or downstream-only or peers-only set.
# Note: This route-map must be called by other route-maps
flt_cml_ixp_out_rtm_get() {
  echo "route-map RTM_CML_FLT_TO_IXP deny 10
 match large-community CMS_UPS_ONLY
exit
!
route-map RTM_CML_FLT_TO_IXP deny 20
 match large-community CMS_DS_ONLY
exit
!
route-map RTM_CML_FLT_TO_IXP deny 30
 match large-community CMS_PEERS_ONLY
exit
!
route-map RTM_CML_FLT_TO_IXP permit 40
 match large-community CMS_IXP_NO_EXPORT
 call RTM_NO_EXPORT
 on-match next
exit
!
route-map RTM_CML_FLT_TO_IXP permit 99
exit"
}

# Deny routes to peers with upstream-only or ixp-only or downstream-only set.
# Note: This route-map must be called by other route-maps
flt_cml_peers_out_rtm_get() {
  echo "route-map RTM_CML_FLT_TO_PEERS deny 10
 match large-community CMS_UPS_ONLY
exit
!
route-map RTM_CML_FLT_TO_PEERS deny 20
 match large-community CMS_IXP_ONLY
exit
!
route-map RTM_CML_FLT_TO_PEERS deny 30
 match large-community CMS_DS_ONLY
exit
!
route-map RTM_CML_FLT_TO_PEERS permit 40
 match large-community CMS_PEERS_NO_EXPORT
 call RTM_NO_EXPORT
 on-match next
exit
!
route-map RTM_CML_FLT_TO_PEERS permit 99
exit"
}

# Upstream route-map for incomming communities
# Note: This route-map must be called by other route-maps
cml_ups_in_rtm_get() {
  echo "route-map RTM_UPS_IN permit 10
 call RTM_CML_IN
 on-match next
exit
!
route-map RTM_UPS_IN permit 20
 set large-community $MY_ASN:1:3000 additive
exit"
}

# Downstream route-map for incomming communities
# Note: This route-map must be called by other route-maps
cml_ds_in_rtm_get() {
  echo "route-map RTM_DS_IN permit 10
 call RTM_CML_IN
 on-match next
exit
!
route-map RTM_DS_IN permit 20
 set large-community $MY_ASN:1:3100 additive
exit
!
route-map RTM_DS_IN permit 30
exit"
}

# Peers route-map for incomming communities
# Note: This route-map must be called by other route-maps
cml_peers_in_rtm_get() {
  echo "route-map RTM_PEER_IN permit 10
 call RTM_CML_IN
 on-match next
exit
!
route-map RTM_PEER_IN permit 20
 set large-community $MY_ASN:1:3200 additive
exit"
}

# IXP route-map for incomming communities
# Note: This route-map must be called by other route-maps
cml_ixp_in_rtm_get() {
  echo "route-map RTM_IXP_IN permit 10
 call RTM_CML_IN
 on-match next
exit
!
route-map RTM_IXP_IN permit 20
 set large-community $MY_ASN:1:3300 additive
exit"
}

# Generate import route-map for specific peer AS ($1) with downstream,
# and its optional local preference ($2), and community tag ($3) for valid rpki,
# and local preference ($4), and community tag ($5) for notfound
peers_in_rtm_get() {
  echo "route-map RTM_IMPORT_FROM_$1 permit 1
 call RTM_INVALID_DENY
 description Drop Invalid Prefixes
 on-match next
exit
!
route-map RTM_IMPORT_FROM_$1 permit 5
 description Peer filter and communities
 call RTM_PEER_IN
 on-match next
exit
!
route-map RTM_IMPORT_FROM_$1 permit 10
 description Import any valid RPKI from $1
 match rpki valid
 match ipv6 address prefix-list PFL_IMPORT_FROM_$1
 match as-path ASP_IMPORT_FROM_$1"

  if [ -n "$2" ];
  then
    echo " set local-preference $2"
  fi
  
  if [ -n "$3" ];
  then
    echo " set large-community $MY_ASN:$3 additive"
  fi

  echo "exit
!
route-map RTM_IMPORT_FROM_$1 permit 20
 description Import any prefix that not found in RPKI db from $1 with lower pref
 match rpki notfound
 match ipv6 address prefix-list PFL_IMPORT_FROM_$1
 match as-path ASP_IMPORT_FROM_$1"

  if [ -n "$4" ];
  then
    echo " set local-preference $4"
  fi
  
  if [ -n "$5" ];
  then
    echo " set large-community $MY_ASN:$5 additive"
  fi

  echo "exit
!
route-map RTM_IMPORT_FROM_$1 deny 99
 description Reject any prefix from $1
 match ipv6 address prefix-list PFL_ANY
exit"
}

# Generate import route-map for specific downstream AS ($1) with downstream,
# and its optional local preference ($2), and community tag ($3) for valid rpki,
# and local preference ($4), and community tag ($5) for notfound
downstream_in_rtm_get() {
  echo "route-map RTM_IMPORT_FROM_$1 permit 1
 call RTM_INVALID_DENY
 description Drop Invalid Prefixes
 on-match next
exit
!
route-map RTM_IMPORT_FROM_$1 permit 5
 description Downstream filter and communities
 call RTM_DS_IN
 on-match next
exit
!
route-map RTM_IMPORT_FROM_$1 permit 10
 description Import any valid RPKI from $1
 match rpki valid
 match ipv6 address prefix-list PFL_IMPORT_FROM_$1
 match as-path ASP_IMPORT_FROM_$1"

  if [ -n "$2" ];
  then
    echo " set local-preference $2"
  fi
  
  if [ -n "$3" ];
  then
    echo " set large-community $MY_ASN:$3 additive"
  fi
  
  echo "exit
!
route-map RTM_IMPORT_FROM_$1 permit 20
 description Import any prefix that not found in RPKI db from $1 with lower pref
 match rpki notfound
 match ipv6 address prefix-list PFL_IMPORT_FROM_$1
 match as-path ASP_IMPORT_FROM_$1"

  if [ -n "$4" ];
  then
    echo " set local-preference $4"
  fi
  
  if [ -n "$5" ];
  then
    echo " set large-community $MY_ASN:$5 additive"
  fi
  
  echo "exit
!
route-map RTM_IMPORT_FROM_$1 deny 99
 description Reject any prefix from $1
 match ipv6 address prefix-list PFL_ANY
exit"
}

# Generate import route-map from upstream $1 without downstream,
# and its optional local preference ($2), and community tag ($3) for valid rpki,
# and local preference ($4), and community tag ($5) for notfound
upstream_in_rtm_get() {
  echo "route-map RTM_IMPORT_FROM_$1 permit 1
 call RTM_INVALID_DENY
 description Drop Invalid Prefixes
 on-match next
exit
!
route-map RTM_IMPORT_FROM_$1 permit 5
 description Upstream filter and communities
 call RTM_UPS_IN
 on-match next
exit
!
route-map RTM_IMPORT_FROM_$1 permit 10
 description Import any valid RPKI from $1
 match rpki valid"

  if [ -n "$2" ];
  then
    echo " set local-preference $2"
  fi
  
  if [ -n "$3" ];
  then
    echo " set large-community $MY_ASN:$3 additive"
  fi
  
  echo "exit
!
route-map RTM_IMPORT_FROM_$1 permit 20
 description Import any prefix that not found in RPKI db from $1 with lower pref
 match rpki notfound"

  if [ -n "$4" ];
  then
    echo " set local-preference $4"
  fi
  
  if [ -n "$5" ];
  then
    echo " set large-community $MY_ASN:$5 additive"
  fi
  
  echo "exit
!
route-map RTM_IMPORT_FROM_$1 deny 99
 description Reject any prefix from $1
 match ipv6 address prefix-list PFL_ANY
exit"
}

# Generate import route-map from IXP $1 without downstream,
# and its optional local preference ($2), and community tag ($3) for valid rpki,
# and local preference ($4), and community tag ($5) for notfound
ixp_in_rtm_get() {
  echo "route-map RTM_IMPORT_FROM_$1 permit 1
 call RTM_INVALID_DENY
 description Drop Invalid Prefixes
 on-match next
exit
!
route-map RTM_IMPORT_FROM_$1 permit 5
 description IXP filter and communities
 call RTM_IXP_IN
 on-match next
exit
!
route-map RTM_IMPORT_FROM_$1 permit 10
 description Import any valid RPKI from $1
 match rpki valid"

  if [ -n "$2" ];
  then
    echo " set local-preference $2"
  fi
  
  if [ -n "$3" ];
  then
    echo " set large-community $MY_ASN:$3 additive"
  fi
  
  echo "exit
!
route-map RTM_IMPORT_FROM_$1 permit 20
 description Import any prefix that not found in RPKI db from $1 with lower pref
 match rpki notfound"

  if [ -n "$4" ];
  then
    echo " set local-preference $4"
  fi
  
  if [ -n "$5" ];
  then
    echo " set large-community $MY_ASN:$5 additive"
  fi
  
  echo "exit
!
route-map RTM_IMPORT_FROM_$1 deny 99
 description Reject any prefix from $1
 match ipv6 address prefix-list PFL_ANY
exit"
}

# Generate export route-map to downstream $1
downstream_out_rtm_get() {
  echo "route-map RTM_EXPORT_TO_$1 permit 1
 call RTM_INVALID_DENY
 description Drop Invalid Prefixes
 on-match next
exit
!
route-map RTM_EXPORT_TO_$1 permit 5
 description Drop Filtered Prefixes
 call RTM_CML_FLT_TO_DS
 on-match next
exit
!
route-map RTM_EXPORT_TO_$1 permit 10
 description Export netwroks with valid RPKI"

 if [ -n "$CML_MY_PREFIX" ];
 then
  echo " match large-community CML_MY_PREFIX"
 fi

 echo " match ipv6 address prefix-list PFL_EXPORT_FROM_AS$MY_ASN
 match rpki valid
exit
!
route-map RTM_EXPORT_TO_$1 permit 20
 description customer routes are provided to Downstream
 match large-community CMS_LEARNT_DS
 match rpki valid
exit
!
route-map RTM_EXPORT_TO_$1 deny 99
 description Export netwroks with specific BGP attributes
 match ipv6 address prefix-list PFL_ANY
exit"
}

# Generate export route-map to IXP $1
ixp_out_rtm_get() {
  echo "route-map RTM_EXPORT_TO_$1 permit 1
 description Drop Invalid Prefixes
 call RTM_INVALID_DENY
 on-match next
exit
!
route-map RTM_EXPORT_TO_$1 permit 5
 description Drop Filtered Prefixes
 call RTM_CML_FLT_TO_IXP
 on-match next
exit
!
route-map RTM_EXPORT_TO_$1 permit 10
 description Export netwroks with valid RPKI"

 if [ -n "$CML_MY_PREFIX" ];
 then
  echo " match large-community CML_MY_PREFIX"
 fi

 echo " match ipv6 address prefix-list PFL_EXPORT_FROM_AS$MY_ASN
 match rpki valid
exit
!
route-map RTM_EXPORT_TO_$1 permit 20
 description customer routes are provided to IXP
 match large-community CMS_LEARNT_DS
 match rpki valid
exit
!
route-map RTM_EXPORT_TO_$1 deny 99
 description Export netwroks with specific BGP attributes
 match ipv6 address prefix-list PFL_ANY
exit"
}

# Generate export route-map to peer $1
peers_out_rtm_get() {
  echo "route-map RTM_EXPORT_TO_$1 permit 1
 description Drop Invalid Prefixes
 call RTM_INVALID_DENY
 on-match next
exit
!
route-map RTM_EXPORT_TO_$1 permit 5
 description Drop Filtered Prefixes
 call RTM_CML_FLT_TO_PEERS
 on-match next
exit
!
route-map RTM_EXPORT_TO_$1 permit 10
 description Export netwroks with valid RPKI"

 if [ -n "$CML_MY_PREFIX" ];
 then
  echo " match large-community CML_MY_PREFIX"
 fi

 echo " match ipv6 address prefix-list PFL_EXPORT_FROM_AS$MY_ASN
 match rpki valid
exit
!
route-map RTM_EXPORT_TO_$1 permit 20
 description customer routes are provided to peers
 match large-community CMS_LEARNT_DS
 match rpki valid
exit
!
route-map RTM_EXPORT_TO_$1 deny 99
 description Export netwroks with specific BGP attributes
 match ipv6 address prefix-list PFL_ANY
exit"
}

# Generate export route-map to upstream $1
upstream_out_rtm_get() {
  echo "route-map RTM_EXPORT_TO_$1 permit 1
 description Drop Invalid Prefixes
 call RTM_INVALID_DENY
 on-match next
exit
!
route-map RTM_EXPORT_TO_$1 permit 5
 description Drop Filtered Prefixes
 call RTM_CML_FLT_TO_UPS
 on-match next
exit
!
route-map RTM_EXPORT_TO_$1 permit 10
 description Export netwroks with valid RPKI"

 if [ -n "$CML_MY_PREFIX" ];
 then
  echo " match large-community CML_MY_PREFIX"
 fi

 echo " match ipv6 address prefix-list PFL_EXPORT_FROM_AS$MY_ASN
 match rpki valid
exit
!
route-map RTM_EXPORT_TO_$1 permit 20
 description customer routes are provided to upstreams
 match large-community CMS_LEARNT_DS
 match rpki valid
exit
!
route-map RTM_EXPORT_TO_$1 deny 99
 description Export netwroks with specific BGP attributes
 match ipv6 address prefix-list PFL_ANY
exit"
}

# Generate export route-map of your asn.
my_out_rtm_get() {
  echo "route-map RTM_EXPORT_FROM_AS$MY_ASN permit 1
 description Drop Invalid Prefixes
 call RTM_INVALID_DENY
 on-match next
exit
!
route-map RTM_EXPORT_FROM_AS$MY_ASN permit 10
 description Export netwroks with specific BGP attributes
 match ipv6 address prefix-list PFL_EXPORT_FROM_AS$MY_ASN
 match rpki valid"

 if [ -n "$CML_MY_PREFIX" ];
 then
  echo " set large-community $MY_ASN:$CML_MY_PREFIX additive"
 fi

 echo "exit
!
route-map RTM_EXPORT_FROM_AS$MY_ASN permit 20
 description Export our netwroks with not working rpki as separate rule
 match ipv6 address prefix-list PFL_EXPORT_FROM_AS$MY_ASN
 match rpki notfound
exit
!
route-map RTM_EXPORT_FROM_AS$MY_ASN deny 99
 description Export netwroks with specific BGP attributes
 match ipv6 address prefix-list PFL_ANY
exit"
}

action_static_rtm_list() {
  invalid_rtm_get
  echo !

  no_export_rtm_get
  echo !

  blackhole_rtm_get
  echo !

  prefmod_rtm_get
  echo !
}

cml_out_static_rtm_list() {
  flt_cml_ups_out_rtm_get
  echo !

  flt_cml_ds_out_rtm_get
  echo !

  flt_cml_ixp_out_rtm_get
  echo !

  flt_cml_peers_out_rtm_get
  echo !
}

cml_in_static_rtm_list() {
  cml_ups_in_rtm_get
  echo !
  
  cml_ds_in_rtm_get
  echo !

  cml_ixp_in_rtm_get
  echo !
  
  cml_peers_in_rtm_get
  echo !
}

cml_static_rtm_list() {
  cml_out_static_rtm_list
  cml_in_static_rtm_list
  my_out_rtm_get
  echo !
}

static_rtm_list() {
  cml_static_rtm_list
  action_static_rtm_list

  # Depends on action_static_rtm_list
  cml_in_rtm_get
  echo !
}

# Get incoming route-map configuration of the peer type ($1)
cfg_in_rtm_get() {
  PEER_TYPE="$1"
  dynamic_asn_yml_get $PEER_TYPE | while read AS
  do
    ${PEER_TYPE}_in_rtm_get $AS "$(localpref_valid_peer_yml_get $AS)" "$(cml_valid_peer_yml_get $AS)"\
     "$(localpref_notfound_peer_yml_get $AS)" "$(cml_notfound_peer_yml_get $AS)"
  done
}

# Get outgoing route-map configuration of the peer type ($1)
cfg_out_rtm_get() {
  PEER_TYPE="$1"
  dynamic_asn_yml_get $PEER_TYPE | while read AS
  do
    ${PEER_TYPE}_out_rtm_get $AS
  done
}

dynamic_rtm_list() {
	for peer_type in $(peer_type_yml_get)
	do
    cfg_in_rtm_get $peer_type
    echo !

    cfg_out_rtm_get $peer_type
    echo !
  done
}

full_rtm_list() {
  static_rtm_list
  dynamic_rtm_list
}