#!/bin/sh

# Find config file
cfg_get() {
	export LIRCTL_CONF;
	if [ -f $HOME/.config/lirctl/lirctl.yaml ]
	then
		export LIRCTL_CONF="$(realpath $HOME/.config/lirctl/lirctl.yaml)"
	elif [ -f /usr/local/etc/lirctl/lirctl.yaml ]
	then
		export LIRCTL_CONF="$(realpath /usr/local/etc/lirctl/lirctl.yaml)"
	elif [ -f /etc/lirctl/lirctl.yaml ]
	then
		export LIRCTL_CONF="$(realpath /etc/lirctl/lirctl.yaml)"
	else
		print_error "(lirctl) Can't find configuration file."
		exit 1
	fi
}

# Run to set its LIRCTL_CONF variables
cfg_get

parse_yml() {
	python3 -m shyaml $@ < $LIRCTL_CONF
}

syntax_yml_error() {
	print_error "You configuration file is invalid."
	exit 1
}

# Pass key variable to this function to check if it's empty
empty_value_yml_check() {
	if [ "None" = "$(parse_yml get-value $1)" ];
	then
		print_error "(cfg) Your $1 variable is not defined."
		exit 1
	fi
}

syntax_yml_check() {
	if [ "config" != "$(parse_yml keys)" ]; then
		syntax_yml_error
	fi

	for peer_type in $(parse_yml keys config);
	do
		case $peer_type in
			"me")
				for me_keys in $(parse_yml keys config.me);
				do
					case $me_keys in
						"number")
							empty_value_yml_check config.me.number
							continue
							;;
						"as-set")
							empty_value_yml_check config.me.as-set
							continue
							;;
						"max-prefix")
							empty_value_yml_check config.me.max-prefix
							continue
							;;
						"prefixes")
							empty_value_yml_check config.me.prefixes
							continue
							;;
						*)
							echo $me_keys
							syntax_yml_error
					esac
				done
				continue
				;;
			"community")
				for community_keys in $(parse_yml keys config.community);
				do
					case $community_keys in
						"blackhole")
							empty_value_yml_check config.community.blackhole
							continue
							;;
						"no-export")
							empty_value_yml_check config.community.no-export
							continue
							;;
						"upstream")
							empty_value_yml_check config.community.upstream
							continue
							;;
						"ixp")
							empty_value_yml_check config.community.ixp
							continue
							;;
						"downstream")
							empty_value_yml_check config.community.downstream
							continue
							;;
						"peers")
							empty_value_yml_check config.community.peers
							continue
							;;
						*)
							echo $community_keys
							syntax_yml_error
					esac
				done
				continue
				;;
			"upstream")
				empty_value_yml_check config.upstream
				continue
				;;
			"downstream")
				empty_value_yml_check config.downstream
				continue
				;;
			"ixp")
				empty_value_yml_check config.ixp
				continue
				;;
			"peers")
				empty_value_yml_check config.peers
				continue
				;;
			*)
				echo $peer_type
				syntax_yml_error
				;;
		esac
	done
}

# What is my AS number?
my_asn_get()
{
	parse_yml get-value config.me.number < $LIRCTL_CONF
}

# What is my as-set?
my_ass_get()
{
	parse_yml get-value config.me.as-set < $LIRCTL_CONF
}

# What is my maximum number of outgoing prefixes
my_max_prefix_get()
{
	parse_yml get-value config.me.max-prefix < $LIRCTL_CONF
}

# List of current configured ixp peers.
ixp_yml_get() {
	echo $(parse_yml keys config.ixp)
}

# List of current configured upstream peers.
upstream_yml_get() {
	echo $(parse_yml keys config.upstream)
}

# List of current configured downstream peers.
downstream_yml_get() {
	echo $(parse_yml keys config.downstream)
}

# List of current configured direct peers.
peers_yml_get() {
	echo $(parse_yml keys config.peers)
}

# List of current configured peers.
peer_type_yml_get() {
	for peer_type in $(parse_yml keys config);
	do
		case $peer_type in
			"me")
				continue
				;;
			"community")
				continue
				;;
			*)
				echo $peer_type
				;;
		esac
	done
}

# List of current configured peers with as-set.
ass_peer_type_yml_get() {
	for peer_type in $(parse_yml keys config);
	do
		case $peer_type in
			"peers")
				echo $peer_type
				continue
				;;
			"downstream")
				echo $peer_type
				continue
				;;
			*)
				continue
				;;
		esac
	done
}

# List of current configured peers without as-set.
ass_rev_peer_type_yml_get() {
	for peer_type in $(parse_yml keys config);
	do
		case $peer_type in
			"upstream")
				echo $peer_type
				continue
				;;
			"ixp")
				echo $peer_type
				continue
				;;
			*)
				continue
				;;
		esac
	done
}

# List of current configured ASN filter by peer type ($1).
dynamic_asn_yml_get() {
	for peer_type in $(peer_type_yml_get)
	do
		case $peer_type in
			"$1")
				echo "$(parse_yml keys config.$peer_type)"
				continue
				;;
			*)
				continue
				;;
		esac
	done
}

# Total number of peers.
num_peers_yml_get() {
	local sum;
	for peer_type in $(peer_type_yml_get)
	do
		sum=$(expr $sum + "$(parse_yml get-length config.$peer_type < $LIRCTL_CONF)")
	done
    if [ "$sum" = 0 ]
	then
        print_error "(cfg) You don't have any peers."
        exit 1
    fi
	echo $sum
}

# List of all ASNs in our peering configurations
asn_yml_get()
{
	for peer_type in $(peer_type_yml_get)
	do
		echo $(parse_yml keys config.$peer_type)
	done
}

# List of ASNs with downstream (defined AS-SET)
ass_asn_yml_get() {
	for peer_type in $(ass_peer_type_yml_get)
	do
		echo $(parse_yml keys config.$peer_type)
	done
}

# List of ASNs without downstream (AS-SET is not defined)
ass_rev_asn_yml_get() {
	for peer_type in $(ass_rev_peer_type_yml_get)
	do
		echo "$(parse_yml keys config.$peer_type)"
	done
}

# List of my prefixes
myself_prefixes_yml_get() {
	parse_yml get-values config.me.prefixes
}

# Get description of peer ($1)
peer_description_yml_get() {
	local PEER_DESC
	for peer_type in $(peer_type_yml_get)
	do
		PEER_DESC=$(parse_yml get-value config.$peer_type.$1.description 2> /dev/null)
		if [ -n "$PEER_DESC" ];
		then
			echo $PEER_DESC
			return
		fi
	done
	if [ -z "$PEER_DESC" ];
	then
		print_error "(cfg) You don't have description for $1"
		exit 1
	fi
}

# Get maximum number of prefixes of peer ($1)
peer_max_prefix_yml_get() {
	local PEER_MAX_PREFIX
	for peer_type in $(peer_type_yml_get)
	do
		PEER_MAX_PREFIX=$(parse_yml get-value config.$peer_type.$1.max-prefix 2> /dev/null)
		if [ -n "$PEER_MAX_PREFIX" ];
		then
			echo $PEER_MAX_PREFIX
			return
		fi
	done
	if [ -z "$PEER_MAX_PREFIX" ];
	then
		print_error "(cfg) You don't have max-prefix for $1"
		exit 1
	fi
}

# Get IP addresses of the peer-group neighbors
neighbors_yml_get() {
	for peer_type in $(peer_type_yml_get)
	do
		if [ -n "$(parse_yml get-values config.$peer_type.$1.neighbors 2> /dev/null)" ];
		then
			parse_yml get-values config.$peer_type.$1.neighbors
			return
		fi
	done
}

# Get update-source ip address from configuration file
upd_src_yml_get() {
	for peer_type in $(peer_type_yml_get)
	do
		if [ -n "$(parse_yml get-value config.$peer_type.$1.upd-src 2> /dev/null)" ];
		then
			parse_yml get-value config.$peer_type.$1.upd-src
			return
		fi
	done
}

# Get local preference of RPKI valid routes of peer from configuration file
localpref_valid_peer_yml_get() {
	for peer_type in $(peer_type_yml_get)
	do
		if [ -n "$(parse_yml get-value config.$peer_type.$1.valid.loc 2> /dev/null)" ];
		then
			parse_yml get-value config.$peer_type.$1.valid.loc
			return
		fi
	done
}

# Get local preference of RPKI not found routes of peer from configuration file
localpref_notfound_peer_yml_get() {
	for peer_type in $(peer_type_yml_get)
	do
		if [ -n "$(parse_yml get-value config.$peer_type.$1.notfound.loc 2> /dev/null)" ];
		then
			parse_yml get-value config.$peer_type.$1.notfound.loc
			return
		fi
	done
}

# Get community tag of RPKI valid routes of peer from configuration file
cml_valid_peer_yml_get() {
	for peer_type in $(peer_type_yml_get)
	do
		if [ -n "$(parse_yml get-value config.$peer_type.$1.valid.community 2> /dev/null)" ];
		then
			parse_yml get-value config.$peer_type.$1.valid.community
			return
		fi
	done
}

# Get community tag of RPKI not found routes of peer from configuration file
cml_notfound_peer_yml_get() {
	for peer_type in $(peer_type_yml_get)
	do
		if [ -n "$(parse_yml get-value config.$peer_type.$1.notfound.community 2> /dev/null)" ];
		then
			parse_yml get-value config.$peer_type.$1.notfound.community
			return
		fi
	done
}

# Get community tag of advertise only of specific peer type ($1) from configuration file
cml_peer_type_adv_only_yml_get() {
	if [ -n "$(parse_yml get-value config.community.$1.advertise_only 2> /dev/null)" ];
	then
		parse_yml get-value config.community.$1.advertise_only
		return
	fi
}

# Get community tag of advertise only of specific peer type ($1) from configuration file
cml_peer_type_no_export_yml_get() {
	if [ -n "$(parse_yml get-value config.community.$1.adv_with_no_export 2> /dev/null)" ];
	then
		parse_yml get-value config.community.$1.adv_with_no_export
		return
	fi
}

# Load my configuration file
cfg_load() {
	# Check for syntax error
	syntax_yml_check

    # Variables
    export MY_ASN="$(my_asn_get)"
	export MY_AS_SET="$(my_ass_get)"
    export MY_MAX_PREFIX="$(my_max_prefix_get)"
    export PEER_LEN="$(num_peers_yml_get)"
	export PEER_LEN0="$(expr $PEER_LEN - 1)"
	export CML_BLACKHOLE="$(parse_yml get-value config.community.blackhole 2> /dev/null)"
	export CML_NO_EXPORT="$(parse_yml get-value config.community.no-export 2> /dev/null)"
}
