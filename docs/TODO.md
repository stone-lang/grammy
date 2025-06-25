# TODO

Here's a list of things I'd like to complete to make Grammy **great**.
(Most of these are boilerplate, so some might not apply.)

## Scanner

- [ ] line continuation (`\` followed immediately by newline)
    - [ ] skip leading whitespace on following line
    - [ ] optional?
- [ ] indentation
    - [ ] optional

## Grammar

- [x] primitive combinators: `str` and `reg`
- [x] primitive combinators: `seq`, `alt`, `rep`
- [x] add `_` to canonical names
- [ ] try out the decorated methods syntax
- [ ] try out the instance methods syntax

## Setup

- [x] git (or jj)
    - [ ] root directory only contains worktrees (git --bare; git worktree add)
        - [ ] and maybe support files (`.gitignore`, `.vscode`, etc)
        - [ ] add git aliases for `worktree add -b` and `switch`
- [x] `.gitignore`
- [x] GitHub project
- [x] `.tool-versions`
- [x] `Gemfile`
- [x] `.rubocop.yml`
- [x] `.markdownlint.yml`
- [x] `.rspec`
- [ ] `.irbrc`
- [ ] `.pryrc`

## Documentation

- [x] comprehensive `README` (and keep it updated)
    - [x] intro
    - [x] table of contents
    - [x] features
    - [ ] installation
    - [x] usage
    - [x] tests
    - [x] contributing
    - [ ] badges (see [shields.io](https://shields.io/))
        - [ ] version
        - [x] license
        - [ ] build status (https://github.com/OWNER/REPO/actions/workflows/WORKFLOW/badge.svg
        )
        - [ ] test coverage
        - [ ] dependencies status
- [x] `TODO`
- [ ] `CHANGELOG` (and keep it updated)
- [x] `LICENSE` file (and keep it updated)
- [ ] code of conduct
- [ ] FAQ

## Automation

- [x] `Makefile` for "standard" common tasks
- [ ] `Rakefile` for "standard" common tasks for Ruby projects
    - [ ] update version
        - [ ] verify that CHANGELOG is updated
    - [ ] upload to RubyGems
    - [ ] update dependencies
        - [ ] Ruby
        - [ ] gems
        - [ ] RuboCop (see if any rules need updated config)
- [x] CI/CD setup (GitHub Actions)
- [x] linting
    - [x] RuboCop
    - [x] markdownlint
- [ ] test coverage
- [ ] code quality metrics
- [ ] pre-commit hooks
    - [ ] linting
    - [ ] tests

## Specs

- [x] RSpec setup
- [ ] unit tests
    - [x] scanner
    - [ ] combinators
    - [x] grammar
    - [ ] parser
    - [x] parse tree
- [ ] integration tests
    - [x] parser
    - [ ] parse tree
    - [ ] AST
- [ ] performance tests
    - [ ] benchmarks
- [ ] property (fuzzing) tests

## Gem

- [ ] create a gem
    - [ ] `gemspec`
    - [ ] upload to RubyGems
- [ ] CLI
    - [ ] `bin/grammy`
    - [ ] install with the gem
    - [ ] `--help`
    - [ ] `--version`
    - [ ] `<grammar_file>` to output a serialized parse tree, with input from `STDIN`

## Support

- [ ] VS Code configuration
    - [ ] tasks (`launch.json`)
    - [ ] recommended extensions
- [ ] snippets
- [ ] ISSUES_TEMPLATE
- [ ] PULL_REQUEST_TEMPLATE
- [ ] `.editorconfig`
