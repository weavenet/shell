all: start

ifndef IMAGE
$(error IMAGE is not set)
endif

docker-build: files
	@echo "Building shell image."
	docker build --tag=${IMAGE} .

files: ~/.ssh/id_rsa.pub
	@echo "Copying '~/.ssh/id_rsa.pub' to 'files/authorized_keys'."
	cp ~/.ssh/id_rsa.pub files/authorized_keys

local:
	ssh ubuntu@localhost

publish:
	bash scripts/publish.sh

start: stop docker-build
	bash scripts/start.sh

stop:
	bash scripts/stop.sh

.PHONY: all files docker-build start stop local
