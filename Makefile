OS=					$$(uname -o)
ARCH=				$$(if [ "$$(uname -m)" = "x86_64" ]; then echo amd64; else uname -m; fi;)
DEBUG=				$$(if [ "${OS}" = "FreeBSD" ]; then echo set -xeouv pipefail; else echo set -xeouv; fi)

MANRSCTL_VERSION=		$$(git rev-parse HEAD)
MANRSCTL_CMD	=	/usr/local/bin/manrsctl

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
	@echo "Installing manrsctl"
	@echo
	@cp -Rv usr /
	@chmod +x ${MANRSCTL_CMD}
	@echo
	@echo "Installing manrsctl configuration"
	@if [ ! -s /usr/local/etc/manrsctl/manrsctl.yaml ]; then\
		cp /usr/local/etc/manrsctl/manrsctl.yaml.sample /usr/local/etc/manrsctl/manrsctl.yaml;\
	else\
		echo "manrsctl configuration file is already exists at /usr/local/etc/manrsctl/manrsctl.yaml.";\
		echo "If you want the new configuration use the following command below:";\
		echo "\tcp /usr/local/etc/manrsctl/manrsctl.yaml.sample /usr/local/etc/manrsctl/manrsctl.yaml";\
	fi

.PHONY: installonly
installonly: deps
	@echo "Installing manrsctl"
	@echo
	@cp -Rv usr /
	@echo
	@echo "This method is for testing / development."

.PHONY: debug
debug:
	@echo
	@echo "Enable Debug"
	@if [ "${OS}" = "FreeBSD" ]; then\
		sed -i '' '1s/$$/\n${DEBUG}/' /usr/local/share/manrsctl/common.sh;\
	else\
		sed -i -e '1s/$$/\n${DEBUG}/' /usr/local/share/manrsctl/common.sh;\
	fi
	@echo "Updating manrsctl version to match git revision."
	@echo "MANRSCTL_VERSION: ${MANRSCTL_VERSION}"
	@sed -i.orig "s/MANRSCTL_VERSION=.*/MANRSCTL_VERSION=${MANRSCTL_VERSION}/" ${MANRSCTL_CMD}
	@echo "This method is for testing & development."
	@echo "Please report any issues to https://github.com/spmzt/manrsctl/issues"

.PHONY: undebug
undebug:
	@echo
	@echo "Disable Debug without reinstall"
	@if [ "${OS}" = "FreeBSD" ]; then\
		sed -i '' '2d' /usr/local/share/manrsctl/common.sh;\
	else\
		sed -i -e '2d' /usr/local/share/manrsctl/common.sh;\
	fi
	@echo "Updating manrsctl version to match git revision."
	@echo "MANRSCTL_VERSION: ${MANRSCTL_VERSION}"
	@sed -i.orig "s/MANRSCTL_VERSION=.*/MANRSCTL_VERSION=${MANRSCTL_VERSION}/" ${MANRSCTL_CMD}
	@echo "This method is for testing & development."
	@echo "Please report any issues to https://github.com/spmzt/manrsctl/issues"

.PHONY: dev
dev: install debug

.PHONY: uninstall
uninstall:
	@echo "Removing manrsctl command"
	@rm -vf ${MANRSCTL_CMD}
	@echo
	@echo "Removing manrsctl sub-commands"
	@rm -rvf /usr/local/share/manrsctl
	@echo
	@echo "Removing man page"
	@rm -rvf /usr/local/share/man/man8/manrsctl.8.gz
	@echo
	@echo "removing sample configuration file"
	@rm -rvf /usr/local/etc/manrsctl/manrsctl.yaml.sample
	@echo
	@echo "removing startup script"
	@rm -vf /usr/local/etc/rc.d/manrsctl
	@if [ ! "${OS}" = "FreeBSD" ]; then rm -vf /etc/systemd/system/*/manrsctl*.service /etc/systemd/system/manrsctl*.service; fi
	@echo "You may need to manually remove other filers if it is no longer needed."
