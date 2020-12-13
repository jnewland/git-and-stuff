mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

.PHONY: default
default: build check

.PHONY: check
check:
	git diff --exit-code Aptfile.lock

.PHONY: build
build:
	if [ -f /Aptfile.lock ]; then \
		sudo apt-get update; \
		sudo apt-get -y install $(cat ./Aptfile | sed 's/#.*//' | grep -v -s -e "^:repo:" | tr '\n' ' '); \
		dpkg -l | grep ii | awk '{print $$2 "=" $$3}' > Aptfile.lock; \
	else \
		docker run --rm -i $(current_dir) cat /Aptfile.lock | tr -d '\r' > Aptfile.lock; \
		docker build -t $(current_dir) .; \
	fi
