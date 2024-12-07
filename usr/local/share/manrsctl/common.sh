#!/bin/sh
#
# Import libraries
# Base library should be first to call
. /usr/local/share/manrsctl/lib/base-lib.sh

# Load the configuration file
. /usr/local/share/manrsctl/lib/cfg.sh
cfg_load

# Helpers
. /usr/local/share/manrsctl/lib/frr.sh
. /usr/local/share/manrsctl/lib/rtm.sh
. /usr/local/share/manrsctl/lib/bgp.sh
. /usr/local/share/manrsctl/lib/asp.sh
. /usr/local/share/manrsctl/lib/pfl.sh
. /usr/local/share/manrsctl/lib/cml.sh
. /usr/local/share/manrsctl/lib/rpki.sh

# Libraries
. /usr/local/share/manrsctl/lib/ipv6-lib.sh
. /usr/local/share/manrsctl/lib/rpki-lib.sh
. /usr/local/share/manrsctl/lib/cron-lib.sh
. /usr/local/share/manrsctl/lib/bgp-lib.sh
