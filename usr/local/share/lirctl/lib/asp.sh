#!/bin/sh

# Generate as path list that matches with any asn
any_asp_get() {
  echo "bgp as-path access-list ASP_ANY permit .*"
}

# Generate bogon ASNs as path list
bogon_asp_get() {
  echo "bgp as-path access-list ASP_BOGON seq 5 deny _0_
bgp as-path access-list ASP_BOGON seq 10 deny _23456_
bgp as-path access-list ASP_BOGON seq 15 deny _6449[6-9]_
bgp as-path access-list ASP_BOGON seq 20 deny _64[5-9][0-9][0-9]_
bgp as-path access-list ASP_BOGON seq 25 deny _6[5-9][0-9][0-9][0-9]_
bgp as-path access-list ASP_BOGON seq 30 deny _[7-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list ASP_BOGON seq 35 deny _1[0-2][0-9][0-9][0-9][0-9]_
bgp as-path access-list ASP_BOGON seq 40 deny _130[0-9][0-9][0-9]_
bgp as-path access-list ASP_BOGON seq 45 deny _1310[0-6][0-9]_
bgp as-path access-list ASP_BOGON seq 50 deny _13107[0-1]_
bgp as-path access-list ASP_BOGON seq 55 deny _45875[2-9]_
bgp as-path access-list ASP_BOGON seq 60 deny _4587[6-9][0-9]_
bgp as-path access-list ASP_BOGON seq 65 deny _458[8-9][0-9][0-9]_
bgp as-path access-list ASP_BOGON seq 70 deny _459[0-9][0-9][0-9]_
bgp as-path access-list ASP_BOGON seq 75 deny _4[6-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list ASP_BOGON seq 80 deny _[5-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list ASP_BOGON seq 85 deny _[0-9][0-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list ASP_BOGON seq 90 deny _[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list ASP_BOGON seq 95 deny _[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list ASP_BOGON seq 100 deny _[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list ASP_BOGON seq 105 permit .*"
}

bogon_rev_asp_get() {
  echo "bgp as-path access-list ASP_REV_BOGON seq 5 permit _0_
bgp as-path access-list ASP_REV_BOGON seq 10 permit _23456_
bgp as-path access-list ASP_REV_BOGON seq 15 permit _6449[6-9]_
bgp as-path access-list ASP_REV_BOGON seq 20 permit _64[5-9][0-9][0-9]_
bgp as-path access-list ASP_REV_BOGON seq 25 permit _6[5-9][0-9][0-9][0-9]_
bgp as-path access-list ASP_REV_BOGON seq 30 permit _[7-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list ASP_REV_BOGON seq 35 permit _1[0-2][0-9][0-9][0-9][0-9]_
bgp as-path access-list ASP_REV_BOGON seq 40 permit _130[0-9][0-9][0-9]_
bgp as-path access-list ASP_REV_BOGON seq 45 permit _1310[0-6][0-9]_
bgp as-path access-list ASP_REV_BOGON seq 50 permit _13107[0-1]_
bgp as-path access-list ASP_REV_BOGON seq 55 permit _45875[2-9]_
bgp as-path access-list ASP_REV_BOGON seq 60 permit _4587[6-9][0-9]_
bgp as-path access-list ASP_REV_BOGON seq 65 permit _458[8-9][0-9][0-9]_
bgp as-path access-list ASP_REV_BOGON seq 70 permit _459[0-9][0-9][0-9]_
bgp as-path access-list ASP_REV_BOGON seq 75 permit _4[6-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list ASP_REV_BOGON seq 80 permit _[5-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list ASP_REV_BOGON seq 85 permit _[0-9][0-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list ASP_REV_BOGON seq 90 permit _[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list ASP_REV_BOGON seq 95 permit _[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list ASP_REV_BOGON seq 100 permit _[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list ASP_REV_BOGON seq 105 deny .*"
}

# Pass your ASN to $1 
myself_asp_get() {
  echo "bgp as-path access-list ASP_MYSELF seq 5 permit ^$
bgp as-path access-list ASP_MYSELF seq 10 permit _$1\_
bgp as-path access-list ASP_MYSELF seq 99 deny .*"
}

# Generate import as path list from $1 AS
in_nods_asp_get() {
  echo "no bgp as-path access-list IMPORT_ASN_FROM_AS$1"
  echo "bgp as-path access-list IMPORT_ASN_FROM_AS$1 deny .*"
}

# Generate import as path list from $1 AS with $2 as-set
in_ds_asp_get() {
  bgpq3 -Dl IMPORT_ASN_FROM_AS$1 -f $1 $2
}

bogon_asp_list() {
    bogon_asp_get
    echo

    bogon_rev_asp_get
    echo
}

static_asp_list() {
    any_asp_get
    echo

    bogon_asp_get
    echo

    bogon_rev_asp_get
    echo
}

dynamic_asp_list() {
    myself_asp_get $MY_ASN
    echo
}

full_asp_list() {
    static_asp_list
    dynamic_asp_list
}