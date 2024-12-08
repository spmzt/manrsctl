#!/bin/sh

# Find config file
cfg_get() {
	export MANRSCTL_CONF;
	if [ -f $HOME/.config/manrsctl/manrsctl.yaml ]
	then
		export MANRSCTL_CONF="$(realpath $HOME/.config/manrsctl/manrsctl.yaml)"
	elif [ -f /usr/local/etc/manrsctl/manrsctl.yaml ]
	then
		export MANRSCTL_CONF="$(realpath /usr/local/etc/manrsctl/manrsctl.yaml)"
	elif [ -f /etc/manrsctl/manrsctl.yaml ]
	then
		export MANRSCTL_CONF="$(realpath /etc/manrsctl/manrsctl.yaml)"
	else
		print_error "(manrsctl) Can't find configuration file."
		exit 1
	fi
}