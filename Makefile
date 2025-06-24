SHELL := /bin/bash

all: setup test lint

setup: bun bundle node_modules/.bin/markdownlint-cli2

test: specs

specs: rspec

console: bundle
	@bundle exec pry -I lib -r grammy

lint: markdownlint rubocop

rspec: bundle
	DEBUG=0 bundle exec rspec

bundle: .tool-versions
	@# Remove vendor/bundle if Ruby version changed
	@current_ruby_version=$$(ruby -e 'print RUBY_VERSION'); \
	desired_ruby_version=$$(grep '^ruby ' .tool-versions | awk '{print $$2}'); \
	if [ -d vendor/bundle ] && [ "$$current_ruby_version" != "$$desired_ruby_version" ]; then \
		echo "Ruby version changed ($$current_ruby_version -> $$desired_ruby_version), removing vendor/bundle..."; \
		rm -rf vendor/bundle; \
	fi
	@if [ .tool-versions -nt Gemfile.lock ] ; then \
		echo running mise ; \
		mise install ruby ; \
		echo running bundle ; \
		bundle install ; \
	elif ! bundle check >/dev/null ; then \
		echo running bundle ; \
		bundle install ; \
	fi

Gemfile.lock: Gemfile
	@bundle install

rubocop:
	bundle exec rubocop .

markdownlint: node_modules/.bin/markdownlint-cli2
	@bunx markdownlint-cli2 '**/*.md' '!vendor' '!node_modules'

node_modules/.bin/markdownlint-cli2:
	@bun install markdownlint-cli2

bun: .tool-versions
	@if [ .tool-versions -nt bun.lock ] ; then \
		echo running mise ; \
		mise install bun ; \
		echo running bundle ; \
		bundle install ; \
	fi

.PHONY: all setup test specs console lint rspec bundle rubocop markdownlint bun
