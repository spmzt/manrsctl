#!/bin/sh

parse_yaml()
{
	python3 -m shyaml $@ < $LIRCTL_CONF
}

get_asn_lists()
{
	for peer in $(seq 0 $PEER_LEN0)
	do
		echo "$(parse_yaml get-value config.peers.$peer.number)"
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

get_my_prefixes()
{
	parse_yaml get-values config.me.prefixes
}

get_peer_upstream_bool()
{
	IS_VALUE_EXIST=false
	for peer in $(seq 0 $PEER_LEN0)
	do
		if [ "$(parse_yaml get-value config.peers.$peer.number)" = "$1" ]
		then
			parse_yaml get-value config.peers.$peer.is_my_upstream
			IS_VALUE_EXIST=true
			break
		fi
	done
	if ! $IS_VALUE_EXIST
	then
		echo "lirctl -> Error: is_my_upstream can be yes or no."
		exit 1
	fi 
}