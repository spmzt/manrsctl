#!/bin/sh

# Pass your blackhole community here ($1)
blackhole_cml_get() {
    echo "bgp large-community-list standard CMS_BLACKHOLE permit $MY_ASN:$CML_BLACKHOLE"
}

# Pass your no-export community before advertising
no_export_cml_get() {
    echo "bgp large-community-list standard CMS_NO_EXPORT permit $MY_ASN:$CML_NO_EXPORT"
}

# Pass your community ($1) for advertise only to other customers
downstream_only_cml_get() {
    echo "bgp large-community-list standard CMS_DS_ONLY permit $MY_ASN:$1"
}

# Pass your community ($1) for advertise only to ixp
ixp_only_cml_get() {
    echo "bgp large-community-list standard CMS_IXP_ONLY permit $MY_ASN:$1"
}

# Pass your community ($1) for advertise only to upstreams
upstream_only_cml_get() {
    echo "bgp large-community-list standard CMS_UPS_ONLY permit $MY_ASN:$1"
}

# Pass your community ($1) for advertise only to peers
peers_only_cml_get() {
    echo "bgp large-community-list standard CMS_PEERS_ONLY permit $MY_ASN:$1"
}

# Pass your community ($1) for advertise to upstreams with no-export
upstream_no_export_cml_get() {
    echo "bgp large-community-list standard CMS_UPS_NO_EXPORT permit $MY_ASN:$1"
}

# Pass your community ($1) for advertise to downstreams with no-export
downstream_no_export_cml_get() {
    echo "bgp large-community-list standard CMS_DS_NO_EXPORT permit $MY_ASN:$1"
}

# Pass your community ($1) for advertise to ixp with no-export
ixp_no_export_cml_get() {
    echo "bgp large-community-list standard CMS_IXP_NO_EXPORT permit $MY_ASN:$1"
}

# Pass your community ($1) for advertise to peers with no-export
peers_no_export_cml_get() {
    echo "bgp large-community-list standard CMS_PEERS_NO_EXPORT permit $MY_ASN:$1"
}

# Set local-pref to least significant 3 digits
# with local preferences of 100, 200, 300, and 400
# And define its least significant 3 digits of community
prefmod_cml_get() {
    echo "bgp large-community-list standard CMS_PREFMOD_100 permit $MY_ASN:1:2100
bgp large-community-list standard CMS_PREFMOD_200 permit $MY_ASN:1:2200
bgp large-community-list standard CMS_PREFMOD_300 permit $MY_ASN:1:2300
bgp large-community-list standard CMS_PREFMOD_400 permit $MY_ASN:1:2400
bgp large-community-list expanded CME_PREFMOD_RANGE permit $MY_ASN:1:2..."
}

# Informational communities
#
# 3000 - learned from upstream
# 3100 - learned from customer (downstream)
# 3200 - learned from peer
# 3300 - learned from IXP
#
info_cml_get() {
    echo "bgp large-community-list standard CMS_LEARNT_UPSTREAM permit $MY_ASN:1:3000
bgp large-community-list standard CMS_LEARNT_DS permit $MY_ASN:1:3100
bgp large-community-list standard CMS_LEARNT_PEER permit $MY_ASN:1:3200
bgp large-community-list standard CMS_LEARNT_IXP permit $MY_ASN:1:3300"
    if [ -n "$CML_MY_PREFIX" ];
    then
        echo "bgp large-community-list standard CMS_OWN_PREFIX permit $MY_ASN:$CML_MY_PREFIX"
    fi
}

static_cml_list() {
    prefmod_cml_get
    echo !
    info_cml_get
    echo !
    blackhole_cml_get
    echo !
    no_export_cml_get
    echo !
}

# Get advertise only community list configuration of the all peer types
dynamic_adv_only_cml_list() {
    for peer_type in $(peer_type_yml_get)
	do
        # Check if the tag exists or not in cfg
        for tag in "$(cml_peer_type_adv_only_yml_get $peer_type)"
        do
            ${peer_type}_only_cml_get $tag
        done
    done
}

# Get no-export community list configuration of the all peer types
dynamic_no_export_cml_list() {
    for peer_type in $(peer_type_yml_get)
	do
        # Check if the tag exists or not in cfg
        for tag in "$(cml_peer_type_no_export_yml_get $peer_type)"
        do
            ${peer_type}_no_export_cml_get $tag
        done
    done
}

# Get community list configuration of the all peer types
dynamic_cml_list() {
    dynamic_adv_only_cml_list
    echo !

    dynamic_no_export_cml_list
    echo !
}

full_cml_list() {
    static_cml_list
    dynamic_cml_list
}