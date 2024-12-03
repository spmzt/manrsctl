#!/bin/sh

# Generate prefix list that matches with any ipv6
any_pfl_get() {
  echo "ipv6 prefix-list PFL_ANY description ALL IPv6 ranges
ipv6 prefix-list PFL_ANY seq 10 permit any"
}

# Generate prefix list that matches with any ipv6
any_rev_pfl_get() {
  echo "ipv6 prefix-list PFL_REV_ANY description None of the IPv6 ranges
ipv6 prefix-list PFL_REV_ANY seq 10 deny any"
}

# Generate prefix list that matches with any ipv4
any_v4_pfl_get() {
  echo "ip prefix-list PFL_V4_ANY description ALL IPv4 ranges
ip prefix-list PFL_V4_ANY seq 10 permit any"
}

# Generate prefix list that matches with any ipv4
any_rev_v4_pfl_get() {
  echo "ip prefix-list PFL_V4_REV_ANY description None of the IPv4 ranges
ip prefix-list PFL_V4_REV_ANY seq 10 deny any"
}

bogon_pfl_get() {
  echo "ipv6 prefix-list PFL_BOGON deny ::/8 le 128
ipv6 prefix-list PFL_BOGON deny 100::/64 le 128
ipv6 prefix-list PFL_BOGON deny 2001:2::/48 le 128
ipv6 prefix-list PFL_BOGON deny 2001:10::/28 le 128
ipv6 prefix-list PFL_BOGON deny 2001:db8::/32 le 128
ipv6 prefix-list PFL_BOGON deny 3fff::/20 le 128
ipv6 prefix-list PFL_BOGON deny 2002::/16 le 128
ipv6 prefix-list PFL_BOGON deny 3ffe::/16 le 128
ipv6 prefix-list PFL_BOGON deny 5f00::/16 le 128
ipv6 prefix-list PFL_BOGON deny fc00::/7 le 128
ipv6 prefix-list PFL_BOGON deny fe80::/10 le 128
ipv6 prefix-list PFL_BOGON deny fec0::/10 le 128
ipv6 prefix-list PFL_BOGON deny ff00::/8 le 128"
}

bogon_v4_pfl_get() {
  echo "ip prefix-list PFL_V4_BOGON deny 0.0.0.0/8 le 32
ip prefix-list PFL_V4_BOGON deny 10.0.0.0/8 le 32
ip prefix-list PFL_V4_BOGON deny 100.64.0.0/10 le 32
ip prefix-list PFL_V4_BOGON deny 127.0.0.0/8 le 32
ip prefix-list PFL_V4_BOGON deny 169.254.0.0/16 le 32
ip prefix-list PFL_V4_BOGON deny 172.16.0.0/12 le 32
ip prefix-list PFL_V4_BOGON deny 192.0.2.0/24 le 32
ip prefix-list PFL_V4_BOGON deny 192.88.99.0/24 le 32
ip prefix-list PFL_V4_BOGON deny 192.168.0.0/16 le 32
ip prefix-list PFL_V4_BOGON deny 198.18.0.0/15 le 32
ip prefix-list PFL_V4_BOGON deny 198.51.100.0/24 le 32
ip prefix-list PFL_V4_BOGON deny 203.0.113.0/24 le 32
ip prefix-list PFL_V4_BOGON deny 224.0.0.0/4 le 32
ip prefix-list PFL_V4_BOGON deny 240.0.0.0/4 le 32"
}

myself_out_pfl_get() {
    echo "ipv6 prefix-list EXPORT_IPV6_NETWORK description my IPv6 prefixes that we want to advertise"
    seq_num=10
    myself_prefixes_yml_get | while read prefix
    do
        echo "ipv6 prefix-list EXPORT_IPV6_NETWORK seq $seq_num permit $prefix"
        seq_num="$(expr $seq_num + 10)"
    done
}

# Generate import prefix list from $1 AS with $2 as-set
ds_in_pfl_get() {
  bgpq3 -m 48 -A6l IMPORT_IPV6_FROM_$1 $2
}

# Generate import prefix list from $1 AS without downstream
nods_in_pfl_get() {
  bgpq3 -m 48 -A6l IMPORT_IPV6_FROM_$1 $1
}

# Generate export prefix list from my AS with downstream
myself_ds_out_pfl_get() {
  bgpq3 -m48 -A6l EXPORT_IPV6_FROM_AS$MY_ASN AS$MY_ASN
}

# Generate import prefix list from my AS without downstream
myself_nods_out_pfl_get() {
  bgpq3 -m 48 -A6l IMPORT_IPV6_FROM_AS$MY_ASN AS$MY_ASN
}

bogon_pfl_list() {
    bogon_pfl_get
    echo

    bogon_v4_pfl_get
    echo
}

static_pfl_list() {
    any_pfl_get
    echo

    any_rev_pfl_get
    echo

    any_v4_pfl_get
    echo

    any_rev_v4_pfl_get
    echo
}

dynamic_pfl_list() {
    myself_out_pfl_get
    myself_ds_out_pfl_get
    echo
}

full_pfl_list() {
    static_pfl_list
    dynamic_pfl_list
}