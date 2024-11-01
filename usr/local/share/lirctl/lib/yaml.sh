#!/bin/sh

# Variables
# shyaml path
SHYAML="python3 -m shyaml"


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
	elif [ -f ./lirctl.yaml ]
	then
		LIRCTL_CONF="$(realpath ./lirctl.yaml)"
	else
		echo "libfrr -> Error: Can't find configuration file."
		exit 1
	fi

	#set -x
	# File Validation
	#$SHYAML -q keys < $LIRCTL_FILE | grep config || (echo "lirctl -> Error: Invalid configuration." && exit 1)
}

parse_yaml()
{
	$SHYAML $@ < $LIRCTL_CONF
}

get_peer_length()
{
	#local length="$(parse_yaml get-length config.peers)
	export PEER_LEN="$(parse_yaml get-length config.peers)"
	export PEER_LEN0="$(expr $PEER_LEN - 1)"
}

get_asn_lists()
{
	for peer in $(seq 0 $PEER_LEN0)
	do
		parse_yaml get-value config.peers.$peer.number
		echo
	done
}

get_asn_with_downstream_lists()
{
	for peer in $(seq 0 $PEER_LEN0)
	do
		if [ "$(parse_yaml get-value config.peers.$peer.downstream)" = "True" ]
		then
			echo "$(parse_yaml get-value config.peers.$peer.number) $(parse_yaml get-value config.peers.$peer.as-set)"
		fi
	done
}

get_asn_without_downstream_lists()
{
	for peer in $(seq 0 $PEER_LEN0)
	do
		if [ "$(parse_yaml get-value config.peers.$peer.downstream)" = "False" ]
		then
			echo "$(parse_yaml get-value config.peers.$peer.number)"
		fi
	done
}
