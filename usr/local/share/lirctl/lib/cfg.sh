#!/bin/sh

# Find config file
cfg_get()
{
	export LIRCTL_CONF;
	if [ -f $HOME/.config/lirctl/lirctl.yaml ]
	then
		echo $(realpath $HOME/.config/lirctl/lirctl.yaml)
	elif [ -f /usr/local/etc/lirctl/lirctl.yaml ]
	then
		echo $(realpath /usr/local/etc/lirctl/lirctl.yaml)
	elif [ -f /etc/lirctl/lirctl.yaml ]
	then
		echo $(realpath /etc/lirctl/lirctl.yaml)
	else
		echo "lirctl -> Error: Can't find configuration file."
		exit 1
	fi

	#set -x
	# File Validation
	#$SHYAML -q keys < $LIRCTL_FILE | grep config || (echo "lirctl -> Error: Invalid configuration." && exit 1)
}

# What is my AS number?
my_asn_get()
{
	python3 -m shyaml get-value config.me.number < $LIRCTL_CONF
}

# What is my as-set?
my_ass_get()
{
	python3 -m shyaml get-value config.me.as-set < $LIRCTL_CONF
}

# What is my maximum number of outgoing prefixes
my_max_prefix_get()
{
	python3 -m shyaml get-value config.me.max_prefix < $LIRCTL_CONF
}

get_my_downstream_bool()
{
	python3 -m shyaml get-value config.me.downstream < $LIRCTL_CONF
}

# Load my configuration file
cfg_load()
{
    # Variables
	export LIRCTL_CONF="$(cfg_get)"
    export MY_ASN="$(my_asn_get)"
	export MY_AS_SET="$(my_ass_get)"
	export HAVE_DOWNSTREAM="$(get_my_downstream_bool)"
    export MAX_PREFIX="$(my_max_prefix_get)"
    export PEER_LEN="$(python3 -m shyaml get-length config.peers 0 < $LIRCTL_CONF)"

    if [ "$PEER_LEN" = 0 ]
	then
        echo "lirctl -> Error: You don't have any peers."
        exit 1
    else
        export PEER_LEN0="$(expr $PEER_LEN - 1)"
    fi
}
