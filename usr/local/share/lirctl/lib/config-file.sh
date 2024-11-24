#!/bin/sh

find_config_file()
{
	export LIRCTL_CONF;
	if [ -f $HOME/.config/lirctl/lirctl.yaml ]
	then
		LIRCTL_CONF="$(realpath $HOME/.config/lirctl/lirctl.yaml)"
	elif [ -f /usr/local/etc/lirctl/lirctl.yaml ]
	then
		LIRCTL_CONF="$(realpath /usr/local/etc/lirctl/lirctl.yaml)"
	elif [ -f /etc/lirctl/lirctl.yaml ]
	then
		LIRCTL_CONF="$(realpath /etc/lirctl/lirctl.yaml)"
	else
		echo "lirctl -> Error: Can't find configuration file."
		exit 1
	fi

	#set -x
	# File Validation
	#$SHYAML -q keys < $LIRCTL_FILE | grep config || (echo "lirctl -> Error: Invalid configuration." && exit 1)
}

get_my_asn()
{
	python3 -m shyaml get-value config.me.number < $LIRCTL_CONF
}

get_my_as_set()
{
	python3 -m shyaml get-value config.me.as-set < $LIRCTL_CONF
}

get_max_prefix()
{
	python3 -m shyaml get-value config.me.max_prefix < $LIRCTL_CONF
}

get_my_downstream_bool()
{
	python3 -m shyaml get-value config.me.downstream < $LIRCTL_CONF
}

load_config_file()
{
    # Variables
    find_config_file

    export MY_ASN="$(get_my_asn)"
	export MY_AS_SET="$(get_my_as_set)"
	export HAVE_DOWNSTREAM="$(get_my_downstream_bool)"
    export MAX_PREFIX="$(get_max_prefix)"
    export PEER_LEN="$(python3 -m shyaml get-length config.peers 0 < $LIRCTL_CONF)"

    if [ "$PEER_LEN" = 0 ]
	then
        echo "lirctl -> Error: You don't have any peers."
        exit 1
    else
        export PEER_LEN0="$(expr $PEER_LEN - 1)"
    fi
}
