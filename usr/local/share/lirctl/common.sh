#!/bin/sh
#
# Import libraries
# Base library should be first to call
. /usr/local/share/lirctl/lib/base-lib.sh

# Load the configuration file
. /usr/local/share/lirctl/lib/cfg.sh
cfg_load

# Helpers
. /usr/local/share/lirctl/lib/frr.sh
. /usr/local/share/lirctl/lib/rtm.sh
. /usr/local/share/lirctl/lib/bgp.sh
. /usr/local/share/lirctl/lib/asp.sh
. /usr/local/share/lirctl/lib/pfl.sh
. /usr/local/share/lirctl/lib/cml.sh

# Libraries
. /usr/local/share/lirctl/lib/ipv6-lib.sh
. /usr/local/share/lirctl/lib/cron-lib.sh
. /usr/local/share/lirctl/lib/bgp-lib.sh
