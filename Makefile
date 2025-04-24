SHELL := /bin/bash
BUNDLE_CHECK := $(shell bundle check >/dev/null ; echo $$?)

all: setup test lint

setup: bun node_modules/.bin/markdownlint-cli2

test: specs

specs: rspec

console: bundle
	@bundle exec pry -I lib -r grammy

lint: markdownlint rubocop

rspec: bundle
	DEBUG=0 bundle exec rspec

bundle:
ifneq ($(BUNDLE_CHECK), 0)
	@bundle
endif

Gemfile.lock: Gemfile
	@bundle

rubocop:
	bundle exec rubocop .

markdownlint: node_modules/.bin/markdownlint-cli2
	@bunx markdownlint-cli2 '**/*.md' '!vendor' '!node_modules'

node_modules/.bin/markdownlint-cli2:
	@bun install markdownlint-cli2

bun:
	@which bun >/dev/null || mise install bun || curl -fsSL https://bun.sh/install | bash

.PHONY: all setup test specs console lint rspec bundle rubocop markdownlint bun
