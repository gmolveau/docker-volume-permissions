# makefile example
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: help
.DEFAULT: help
help: ## show the usage
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk -F ':.*?## ' 'NF==2 {printf "%-35s %s\n", $$1, $$2}'

.PHONY: run
run: ## start the compose stack
	PUID=$(SHELL id -u) PGID=$(SHELL id -g) docker compose up -d
