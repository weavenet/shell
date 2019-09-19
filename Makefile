ifeq ($(SHELL_FLAVOR),)
	SHELL_FLAVOR := amazon
endif

all:
	@echo "Valid targets:"
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

image: authorized_keys
	@echo "Building '${SHELL_FLAVOR}' shell image."
	docker build -f ${SHELL_FLAVOR}/Dockerfile --tag=${SHELL_FLAVOR} .

authorized_keys: ~/.ssh/id_rsa.pub
	@echo "Copying '~/.ssh/id_rsa.pub' to 'files/authorized_keys'."
	cp ~/.ssh/id_rsa.pub files/authorized_keys

clean: stop
	bash scripts/clean.sh ${SHELL_FLAVOR}

local:
	ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no user@localhost

start: stop
	bash scripts/start.sh ${SHELL_FLAVOR}

stop:
	bash scripts/stop.sh

.PHONY: all authorized_keys clean image local start stop
