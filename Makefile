SHELL := /bin/bash
BUNDLE_CHECK := $(shell bundle check >/dev/null ; echo $$?)

all: setup test lint

setup:
	npm install markdownlint-cli2

test: specs

specs: rspec

console: bundle
	bundle exec pry -I lib -r grammy

lint: markdownlint rubocop

rspec: bundle
	DEBUG=0 bundle exec rspec

bundle:
ifneq ($(BUNDLE_CHECK), 0)
	bundle
endif

Gemfile.lock: Gemfile
	bundle

rubocop:
	bundle exec rubocop .

markdownlint:
	markdownlint-cli2 '**/*.md' '!vendor' '!node_modules'

.PHONY: all setup test specs console lint rspec bundle rubocop markdownlint
