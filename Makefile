OS=					$$(uname -o)
ARCH=				$$(if [ "$$(uname -m)" = "x86_64" ]; then echo amd64; else uname -m; fi;)
DEBUG=				$$(if [ "${OS}" = "FreeBSD" ]; then echo set -xeouv pipefail; else echo set -xeouv; fi)

LIRCTL_VERSION=		$$(git rev-parse HEAD)
LIRCTL_CMD	=	/usr/local/bin/lirctl

.PHONY: all
all:
	@echo "Nothing to be done. Please use make install or make uninstall"

.PHONY: deps
deps:
	@echo "Install applications"
	@if [ -e /etc/debian_version ]; then\
		DEBIAN_FRONTEND=noninteractive apt install -y net-tools git python3-pip;\
	elif [ "${OS}" = "FreeBSD" ]; then\
		pkg install -y git-lite python3 py311-pip bgpq3;\
	fi
	@echo
	@echo "Install python applications"
	@pip install -r requirements.txt

.PHONY: install
install:
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

.PHONY: installonly
installonly: deps
	@echo "Installing lirctl"
	@echo
	@cp -Rv usr /
	@echo
	@echo "This method is for testing / development."

.PHONY: debug
debug:
	@echo
	@echo "Enable Debug"
	@if [ "${OS}" = "FreeBSD" ]; then\
		sed -i '' '1s/$$/\n${DEBUG}/' /usr/local/share/lirctl/common.sh;\
	else\
		sed -i -e '1s/$$/\n${DEBUG}/' /usr/local/share/lirctl/common.sh;\
	fi
	@echo "Updating lirctl version to match git revision."
	@echo "LIRCTL_VERSION: ${LIRCTL_VERSION}"
	@sed -i.orig "s/LIRCTL_VERSION=.*/LIRCTL_VERSION=${LIRCTL_VERSION}/" ${LIRCTL_CMD}
	@echo "This method is for testing & development."
	@echo "Please report any issues to https://github.com/spmzt/lirctl/issues"

.PHONY: undebug
undebug:
	@echo
	@echo "Disable Debug without reinstall"
	@if [ "${OS}" = "FreeBSD" ]; then\
		sed -i '' '2d' /usr/local/share/lirctl/common.sh;\
	else\
		sed -i -e '2d' /usr/local/share/lirctl/common.sh;\
	fi
	@echo "Updating lirctl version to match git revision."
	@echo "LIRCTL_VERSION: ${LIRCTL_VERSION}"
	@sed -i.orig "s/LIRCTL_VERSION=.*/LIRCTL_VERSION=${LIRCTL_VERSION}/" ${LIRCTL_CMD}
	@echo "This method is for testing & development."
	@echo "Please report any issues to https://github.com/spmzt/lirctl/issues"

.PHONY: dev
dev: install debug

.PHONY: uninstall
uninstall:
	@echo "Removing lirctl command"
	@rm -vf ${LIRCTL_CMD}
	@echo
	@echo "Removing lirctl sub-commands"
	@rm -rvf /usr/local/share/lirctl
	@echo
	@echo "Removing man page"
	@rm -rvf /usr/local/share/man/man8/lirctl.8.gz
	@echo
	@echo "removing sample configuration file"
	@rm -rvf /usr/local/etc/lirctl/lirctl.yaml.sample
	@echo
	@echo "removing startup script"
	@rm -vf /usr/local/etc/rc.d/lirctl
	@if [ ! "${OS}" = "FreeBSD" ]; then rm -vf /etc/systemd/system/*/lirctl*.service /etc/systemd/system/lirctl*.service; fi
	@echo "You may need to manually remove other filers if it is no longer needed."
