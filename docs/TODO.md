# TODO

Here's a list of things I'd like to complete to make Grammy **great**.

## Scanner

- [ ] line continuation
    - [ ] `\` followed immediately by newline (traditional)
    - [ ] newline followed immediately by `\` (more visible)
    - [ ] skip leading whitespace on following line
    - [ ] optional per grammar
    - [ ] optional per rule
- [ ] indentation

## Grammar

- [x] primitive combinators: `str` (AKA `lit`) and `reg`
- [x] primitive combinators: `seq`, `alt`, `rep`
- [x] primitive combinators: `eol`/`sol`, `eof`/`sof`
- [x] primitive combinators: `wsp`
- [x] add `_` to canonical names (where it makes sense)
- [ ] combinator aliases
    - [ ] `zero_or_more` / `_any`
    - [ ] `one_or_more` / `_some`
    - [ ] `zero_or_one` / `optional` (and maybe `_opt`?)
- [x] rules
    - [x] DSL syntax
        - `rule(:expression) { term + (str("+") + term)[0..] }`
    - [ ] try instance methods syntax
        - `def expression = term + (str("+") + term)[0..]`
    - [ ] try decorated methods syntax
        - `rule def expression = term + (str("+") + term)[0..]`
- [x] start rule
    - [x] defaults to first defined rule
- [x] `terminal` (AKA `token`) rules
- [ ] AST generation
    - [x] tree transformation DSL
    - [ ] AST builder
    - [ ] actions in grammar rules
- [x] user-defined combinators
- [ ] error handling
    - [ ] error messages
    - [ ] error recovery
    - [ ] `fail`/`catch` combinators?
- [ ] packrat caching/memoization
- [ ] lookahead predicates
    - [ ] "and" lookahead predicate
    - [ ] "not" lookahead predicate
- [ ] "cut operator"
    - [ ] combinator?
    - [ ] automatic insertion
- [ ] automatic left recursion support

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
        - [ ] build status (https://github.com/OWNER/REPO/actions/workflows/WORKFLOW/badge.svg)
        - [ ] test coverage
        - [ ] dependencies status
- [x] `TODO` (and keep it updated)
- [ ] `CHANGELOG` (and keep it updated)
- [x] `LICENSE` file (and keep it updated)
- [ ] code of conduct
- [ ] FAQ

## Automation

- [x] `Makefile` for "standard" common tasks
- [x] `Rakefile` for "standard" common tasks for Ruby projects
    - [ ] update version
        - [ ] verify that CHANGELOG is updated
    - [x] upload to RubyGems
    - [ ] update dependencies
        - [ ] Ruby
        - [ ] gems
        - [ ] RuboCop (see if any rules need updated config)
        - [ ] bun
- [x] CI/CD setup (GitHub Actions)
- [x] linting
    - [x] RuboCop
    - [x] markdownlint
    - [ ] Reek
    - [ ] bundler-audit
- [ ] test coverage
- [ ] code quality metrics
- [ ] git hooks (pre-commit, pre-push, etc)
    - [ ] linting
    - [ ] tests
    - [ ] security checks (bundle audit, etc)
- [ ] ISSUES_TEMPLATE
- [ ] PULL_REQUEST_TEMPLATE
- [ ] `.editorconfig`

## Specs

- [x] RSpec setup
- [ ] unit tests
    - [x] scanner
    - [ ] combinators
    - [x] grammar
    - [x] parse tree
    - [ ] AST builder
- [ ] integration tests
    - [x] parser
    - [ ] parse tree
    - [ ] grammar
    - [ ] AST builder
    - [ ] user-defined combinators
    - [ ] rule actions
- [ ] performance tests
    - [ ] benchmarks
- [ ] property (fuzzing) tests

## Gem

- [x] publish a gem
    - [x] `gemspec`
    - [x] publish to RubyGems
- [ ] CLI
    - [ ] `bin/grammy`
    - [ ] install with the gem
    - [ ] `--help`
    - [ ] `--version`
    - [ ] `--json` (use JSON nesting for parse tree nesting)
    - [ ] `<grammar_file>` to output a serialized parse tree, with input from `STDIN`

## Support

- [ ] VS Code configuration
    - [ ] tasks (`launch.json`)
    - [ ] recommended extensions
