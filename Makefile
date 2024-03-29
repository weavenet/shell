ifeq ($(SHELL_OS),)
	SHELL_OS := amazon
endif

all: clean authorized_keys image start

commands:
	@echo "Valid targets:"
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

image: authorized_keys
	@echo "Building '${SHELL_OS}' shell image."
	docker build -f ${SHELL_OS}/Dockerfile --tag=${SHELL_OS} . > ${TMPDIR}/shell.out 2>&1

authorized_keys: ~/.ssh/id_rsa.pub
	@echo "Copying '~/.ssh/id_rsa.pub' to 'files/authorized_keys'."
	cp ~/.ssh/id_rsa.pub files/authorized_keys

clean: stop
	bash scripts/clean.sh amazon
	bash scripts/clean.sh ubuntu

local:
	ssh -p 2222 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no user@localhost

start: stop
	bash scripts/start.sh ${SHELL_OS}
	@echo "Run 'make local' to connect."

status:
	bash scripts/status.sh

stop:
	bash scripts/stop.sh

.PHONY: all authorized_keys clean image local start stop
