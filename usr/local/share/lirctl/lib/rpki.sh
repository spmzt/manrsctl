#!/bin/sh

servers_rpki_get() {
    LEN=$(parse_yml get-length config.rpki)
	if [ $LEN -lt 1 ];
	then
		return
	fi
    echo "rpki"
    for i in $(seq 0 `expr $LEN - 1`);
    do
        echo " rpki cache $(parse_yml get-value config.rpki.$i.type) \
$(parse_yml get-value config.rpki.$i.server) $(parse_yml get-value config.rpki.$i.port) \
precedence $(parse_yml get-value config.rpki.$i.precedence)"
    done
    echo "exit"
}
