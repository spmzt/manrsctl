#!/bin/sh
#
# Import libraries
# Base library should be first to call
. /usr/local/share/lirctl/lib/base-lib.sh

# Load the configuration file
. /usr/local/share/lirctl/lib/config-file.sh
load_config_file

. /usr/local/share/lirctl/lib/yaml.sh
. /usr/local/share/lirctl/lib/frr.sh
. /usr/local/share/lirctl/lib/generator.sh
. /usr/local/share/lirctl/lib/bgp.sh

# Depends on libraries above
. /usr/local/share/lirctl/lib/cron-lib.sh
