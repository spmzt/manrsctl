#!/bin/sh
#
# Import libraries (Call base-lib first)
. /usr/local/share/manrsctl/lib/base-lib.sh

# Find the configuration file
# You need to find and load manrs configuration before import other libs
. /usr/local/share/manrsctl/lib/cnf.sh
# Run to set its MANRSCTL_CONF variables
cfg_get

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
