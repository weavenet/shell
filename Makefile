all: test

docker-build:
	@echo Building shell image
	docker build -q --tag=shell .

shell: docker-build
	docker run -it --entrypoint /bin/bash shell:latest
