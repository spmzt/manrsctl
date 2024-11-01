LIRCTL_CMD	=	/usr/local/bin/lirctl

.PHONY: installonly
installonly:
	@echo "Installing lirctl"
	@echo
	@cp -Rv usr /
	@chmod +x ${LIRCTL_CMD}
	@echo
	@echo "Installing lirctl configuration"
	@if [ ! -s /usr/local/etc/lirctl/lirctl.yaml ]; then\
		cp /usr/local/etc/lirctl/lirctl.yaml.sample /usr/local/etc/lirctl/lirctl.yaml;\
	else\
		echo "lirctl configuration file is already exists at /usr/local/etc/lirctl/lirctl.yaml.";\
		echo "If you want the new configuration use the following command below:";\
		echo "\tcp /usr/local/etc/lirctl/lirctl.yaml.sample /usr/local/etc/lirctl/lirctl.yaml";\
	fi

