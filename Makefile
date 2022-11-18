# Development management facilities
#
# This file specifies useful routines to streamline development management.
# See https://www.gnu.org/software/make/.


# Consume environment variables
ifneq (,$(wildcard .env))
	include .env
endif

# Tool configuration
SHELL := /bin/bash
GNUMAKEFLAGS += --no-print-directory

# Path record
ROOT_DIR ?= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
SOURCE_DIR ?= $(ROOT_DIR)/src

# Target files
ENV_FILE ?= .env
EPHEMERAL_ARCHIVES ?=
GENERATED_ARCHIVES ?=

# Behavior setup
PROJECT_NAME ?= $(shell basename $(ROOT_DIR) | tr a-z A-Z)

# Executables definition
GIT ?= git
REMOVE ?= rm --force --recursive


%: # Treat unrecognized targets
	@ printf "\033[31;1mUnrecognized routine: '$(*)'\033[0m\n"
	$(MAKE) help

help:: ## Show this help
	@ printf "\033[33;1m$(PROJECT_NAME)'s GNU-Make available routines:\n"
	egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[37;1m%-20s\033[0m %s\n", $$1, $$2}'

prepare:: ## Inicialize virtual environment
	test -r $(ENV_FILE) -o ! -r $(ENV_FILE).example || cp $(ENV_FILE).example $(ENV_FILE)

init:: veryclean prepare ## Configure development environment
	$(GIT) submodule update --init --recursive

up:: build execute ## Build and execute service

build:: clean compile ## Build service running environment

compile:: ## Treat file generation

watch:: ## Continuously build project based on source files change
	while true; do \
		watch --no-title --chgexit \
			ls -lR $(SOURCE_DIR) \
		&& $(MAKE) build; \
	done;

execute:: setup run ## Setup and run application

setup:: finish clean ## Process source code into an executable program

run:: ## Launch application locally

finish:: ## Stop application execution

status:: ## Present service running status

ping:: ## Verify service reachability

browse:: ## Access service via browser

test:: ## Verify application's behavior requirements completeness

release:: ## Release a new project version

publish:: ## Publish current project version

deploy:: ## Deploy service on cloud infrastructure

clean:: ## Delete project ephemeral archives
	-$(REMOVE) $(EPHEMERAL_ARCHIVES)

veryclean:: clean ## Delete all generated files
	-$(REMOVE) $(GENERATED_ARCHIVES)


.EXPORT_ALL_VARIABLES:
.ONESHELL:
.PHONY: help prepare init up build compile watch execute setup run finish status ping browse test release publish deploy clean veryclean
