mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

.PHONY: default
default: build check

.PHONY: check
check: generate
	git diff --exit-code Aptfile.lock

.PHONY: build
build:
	docker build -t $(current_dir) .

.PHONY: generate
generate: build
	docker run --rm -i $(current_dir) cat /Aptfile.lock | tr -d '\r' > Aptfile.lock