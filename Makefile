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
BUILD_DIR ?= $(ROOT_DIR)/build

# Target files
ENV_FILE ?= .env
EPHEMERAL_ARCHIVES ?=
GENERATED_ARCHIVES ?= \
	$(BUILD_DIR) \
	$(ROOT_DIR)/node_modules

# Behavior setup
PROJECT_NAME ?= $(shell basename $(ROOT_DIR) | tr a-z A-Z)
HOST ?= localhost
PORT ?= 3000
URL ?= http://$(HOST):$(PORT)

# Executables definition
CP ?= cp --force --recursive
GIT ?= git
REMOVE ?= rm --force --recursive
NPM ?= npm
NPX ?= $(NPM) exec
SASS ?= $(NPX) sass
HTTP_SERVER ?= $(NPX) http-server


%: # Treat unrecognized targets
	@ printf "\033[31;1mUnrecognized routine: '$(*)'\033[0m\n"
	$(MAKE) help

help:: ## Show this help
	@ printf "\033[33;1m$(PROJECT_NAME)'s GNU-Make available routines:\n"
	egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[37;1m%-20s\033[0m %s\n", $$1, $$2}'

prepare:: ## Inicialize virtual environment
	test -r $(ENV_FILE) -o ! -r $(ENV_FILE).example || cp $(ENV_FILE).example $(ENV_FILE)

init:: veryclean prepare $(REQUIREMENTS_TXT) ## Configure development environment
	$(GIT) submodule update --init --recursive
	$(NPM) install

up:: build execute ## Build and execute service

build:: clean $(SOURCE_DIR) ## Build service running environment
	$(CP) $(SOURCE_DIR) $(BUILD_DIR)/
	$(SASS) --update $(SOURCE_DIR)/scss:$(BUILD_DIR)/css

watch:: ## TODO: Treat file generation continuosly
	while true; do \
		watch --no-title --chgexit ls -lR ${SOURCE_DIR} && ${MAKE} build; \
	done;

execute:: setup run ## Setup and run application

setup:: compile ## Process source code into an executable program

compile:: ## Treat file generation

run:: ## Launch application locally
	$(HTTP_SERVER) $(BUILD_DIR) --port $(PORT)

finish:: ## Stop application execution

status:: ## Present service running status

ping:: ## Verify service reachability
	curl $(URL)  #TODO: complement

open:: ## Reach service via browser
	google-chrome --incognito $(URL)

test:: ## Verify application's behavior requirements completeness

release:: ## Release a new project version

publish:: ## Publish current project version

deploy:: ## Deploy service on remote server

clean:: ## Delete project ephemeral archives
	-$(REMOVE) $(EPHEMERAL_ARCHIVES)

veryclean:: clean ## Delete all generated files
	-$(REMOVE) $(GENERATED_ARCHIVES)


.EXPORT_ALL_VARIABLES:
.ONESHELL:
.PHONY: help prepare init up build watch execute setup compile run finish status ping test release publish deploy clean veryclean
