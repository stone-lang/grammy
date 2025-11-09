# TODO

## IMMEDIATE (DO NOT COMMIT!) - Check these off below

- [ ] Update gem
    - Also allow other person to use `preserves` gem name

- [ ] AI thread:

~~~markdown
Prompt: Allow user-defined combinators to wrap non-terminal rules

## Problem

Currently, user-defined combinators in Grammy can only wrap terminals (matchers), not rules (non-terminals).

Example that DOESN'T work:
```ruby
class MyGrammar < Grammy::Grammar
  start :expr
  rule(:expr) { parens(number) }
  rule(:number) { reg(/\d+/) }  # Non-terminal rule

  def parens(exp) = str("(") + exp + str(")")
end
```

When `number` is called as a rule, it executes immediately and returns a `ParseTree`, not a `Matcher`. The sequence combinator (`+`) then fails because it can't work with ParseTrees.

Example that DOES work (using a terminal):
```ruby
class MyGrammar < Grammy::Grammar
  start :expr
  rule(:expr) { parens(number) }
  terminal(:number, /\d+/)  # Terminal - returns a Matcher

  def parens(exp) = str("(") + exp + str(":")
end
```

## Goal

Make it possible to pass rule references (non-terminals) to user-defined combinators, so `parens(number)` works whether `number` is a terminal or a rule.

## Context

- File: `lib/grammy/grammar.rb`
- When a rule is called within a rule block, it should return something that can be composed with combinators
- The grammar DSL currently uses `instance_eval` to evaluate rule blocks
- Test file: `spec/grammar/user_defined_combinator_spec.rb`

## Constraints

- Don't break existing functionality with terminals
- Maintain the clean DSL syntax
- Keep the rule execution model intact for normal rule calls
- Should work with all combinators (`+`, `|`, `[]`, etc.)

## Test Case

```ruby
class UserDefinedGrammar < Grammy::Grammar
  start :us
  rule(:us) { parens(number) }
  rule(:number) { reg(/\d+/) }  # Should work as a rule now

  def parens(exp) = str("(") + exp + str(")")
end

# Should parse "(123)" successfully
```
~~~

- [ ] COMMIT: BUGFIX: rules are able to reference other nested rules
    - lib/grammy/grammar.rb and tests

- [ ] Tree.each specs
    - git fixup where I added `Enumerable`
    - move specs to proper place
    - commit message should mention pre-order traversal.
- [ ] Add AST transformation DSL
    - I may have already tried to commit it, but missed `lib/ast*` and `spec/ast_spec.rb`
    - Does `tree.each` traversal help?
- [ ] AI-assisted refactoring (suggestions, missing, etc)
    - [x] tests
    - [ ] code
        - [ ] Rename Matcher to Primitive or Combinator?
            - [ ] I suppose `custom.rb` would be the only other file in `combinators`
    - [ ] README
    - [ ] TODO
- [ ] add `Makefile` / `Rakefile` rules for common tasks (AI) (BELOW)
    - [ ] publish to RubyGems (BELOW)
        - [ ] check that the `CHANGELOG` is updated
    - [ ] update version (BELOW)
    - [ ] update dependencies (BELOW)
        - [ ] Ruby
        - [ ] gems
        - [ ] RuboCop (see if any rules need updated config)
        - [ ] bun

- [x] START ON STONE 0.10!

- [ ] CHANGELOG

- [ ] https://guides.rubygems.org/security/

- [ ] combinator aliases (BELOW)
    - [ ] `zero_or_more`
    - [ ] `one_or_more`
    - [ ] `zero_or_one`, `optional` (and maybe `_opt`?)
    - [ ] update README/TODO

- Release VERSION 0.11

- [ ] indentation (BELOW)
    - [ ] README updates
- [ ] CHANGELOG

- Release VERSION 0.12

- [ ] line continuation (BELOW)
    - [ ] README updates
- [ ] CHANGELOG

- Release VERSION 0.13

- [ ] error handling (BELOW)
- [ ] CHANGELOG

- Release VERSION 0.14

- [ ] AI prompts
    - [ ] Copilot
    - [ ] Claude
    - [ ] ChatGPT
- [ ] easier debugging (lib/extensions/debug.rb)
- [ ] CHANGELOG

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
