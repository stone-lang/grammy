# Grammy

Grammy is a tool for generating parsers.
You describe the language with a grammar written in a Ruby [DSL], similar to [EBNF].
Grammy dynamically generates a parser from that description.
You can then use the parser to parse strings into a [parse tree],
and create an [AST] from the parse tree.

[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-v0.1-blue.svg)](https://github.com/stone-lang/stone/blob/master/src/stone/version.rb)
[![Gem Version](https://img.shields.io/gem/v/grammy)](https://rubygems.org/gems/grammy)

## ToC

- [Features](#features)
- [Usage](#usage)
- [Combinators](#combinators)
- [Parse Tree](#parse-tree)
- [AST](#ast)
- [Tests](#tests)
- [License](#license)
- [Contributing](#contributing)
- [Changelog](./docs/CHANGELOG.md)
- [TODO](./docs/TODO.md)

## Features

Grammy implements a [PEG] (Parsing Expression Grammar) parser.
But that's an implementation detail, possibly subject to change,
if something better comes along (LPEG, GLR, etc).
PEG parsers are quick (using "packrat" caching) and easy to use.
They easily handle ambiguous grammars, left or right recursion, and infinite lookahead.

You can use Grammy to parse complex languages.
I'm going to be using it to write a full general-purpose programming language.
But you can also use it to parse simpler languages, like:

- JSON
- CSV
- external DSLs
- configuration files
- data formats
- HTTP headers

Basically, if you have an [EBNF] grammar, it should be easy to use Grammy to parse it.

## Usage

~~~ ruby
require "grammy"
require "arithmetic" # Your grammar file, as below.

input = "1+2*3"
parse_tree = Arithmetic.parse(input)
ast = parse_tree.ast
~~~

I'm still experimenting with a few different DSL syntaxes for the grammar.

### Class Methods

~~~ ruby
require 'grammy'

class Arithmetic < Grammy::Grammar
  # Specify which rule to start with.
  start :expression

  # Define the rules.
  rule(:expression) { term + (str("+") + term)[0..] }
  rule(:term) { factor + (str("*") + factor)[0..] }
  rule(:factor) { number | parens(expression) }
  rule(:number) { reg(/\d+/) }

  # Define any custom combinators.
  def parens(exp) = str("(") + expression + str(")")
end
~~~

### Decorated Methods

~~~ ruby
require 'grammy'

class Arithmetic < Grammy::Grammar
  # Specify which rule to start with.
  start :expression

  # Define the rules.
  rule def expression = term + (str("+") + term)[0..]
  rule def term = factor + (str("*") + factor)[0..]
  rule def factor = number | parens(expression)
  rule def number = reg(/\d+/)

  # Define any custom combinators.
  def parens(exp) = str("(") + expression + str(")")
end
~~~

### Instance Methods

~~~ ruby
require 'grammy'

class Arithmetic < Grammy::Grammar
  # Specify which rule to start with.
  start :expression

  # Define the rules.
  def expression = rule { term + (str("+") + term)[0..] }
  def term = rule { factor + (str("*") + factor)[0..] }
  def factor = rule { number | parens(expression) }
  def number = rule { reg(/\d+/) }

  # Define any custom combinators.
  def parens(exp) = str("(") + expression + str(")")
end
~~~

## Combinators

Grammy uses combinators to define the grammar.
Combinators are functions that take one or more parsers as arguments and return a new parser.

Only a few primitive combinators are needed.

### String

The `str` combinator is used to match a string; it has an alias of `lit` (for "literal").

~~~ ruby
str("return")
lit("return")
~~~

### Regex

The `reg` combinator is used to match a regular expression.

~~~ ruby
reg(/\d+/)
~~~

### Sequence

You use the `seq` combinator to specify a sequence of what to match.

This example matches a sequence of a term, a plus sign, and another term.

~~~ ruby
seq(term, str("+"), term)
~~~

### Alternatives

The `alt` combinator is used to specify alternatives (multiple choices) of what to match.

This example matches either a plus sign or a minus sign.

~~~ ruby
alt(str("+"), str("-"))
~~~

> [!NOTE]
> In practical use, this would most likely be done with a single `reg` call:
>
> ~~~ ruby
> reg(/[+-]/)
> ~~~

### Repetition

The `rep` combinator is used to specify repetition of what to match.
You can specify the minimum and maximum number of repetitions, using a range.

This example matches one or more digits.

~~~ ruby
rep(reg(/\d+/), 1..)
~~~

### Operator DSL

You can use `+`, `|`, and `[]` operators in place of the named combinators.
The `+` operator can be used in place of the `seq` combinator.
The `|` operator can be used in place of the `alt` combinator.
The `[]` operator can be used in place of the `rep` combinator.

For example, the following two lines are equivalent:

~~~ ruby
seq(alt(term, expr), str("+"), rep(term, 0..1))
(term | expr) + lit("+") + term[0..1]
~~~

### Start/End of Line/File

The `eol` and `sol` combinators match the end of a line and the start of a line.
The `eof` and `sof` combinators match the end of a file and the start of a file.

## Whitespace

The `wsp` combinator matches any whitespace characters, including tab, newline, carriage return, etc.

## Parse Tree

The internal nodes of the parse tree are ParseTree objects.
The leaves of the parse tree are Token objects.

The parse tree generated by the example above will look like this:

~~~ ruby
expected_parse_tree = ParseTree.new("expression", [
  ParseTree.new("term", [
    ParseTree.new("factor", [
      ParseTree.new("number", [
        Token.new("1")
      ])
    ])
  ]),
  Token.new("+"),
  ParseTree.new("term", [
    ParseTree.new("factor", [
      ParseTree.new("number", [
        Token.new("2")
      ]),
    Token.new("*"),
    ParseTree.new("factor", [
      ParseTree.new("number", [
        Token.new("3")
      ])
    ])
  ])
])
~~~


## AST

The AST will be generated from the parse tree.
The nodes of the AST will be classes that inherit from `AST`.

TODO: How this will work is still TBD.
It will likely be an additional DSL added to the grammar rules.
Or it might be a separate DSL.

The AST generated by the example above will look like this:

~~~ ruby
expected_ast = AST::Arithmetic.new(
  AST::BinaryOp.new("+", [
    AST::Number.new("1"),
    AST::BinaryOp.new("*", [
      AST::Number.new("2"),
      AST::Number.new("3")
    ])
  ])
)
~~~

## Tests

~~~ shell
rspec
~~~

## License

Copyright (c) 2024-2025 by Craig Buchek and BoochTek, LLC.

This code is licensed under the MIT License.
See the [LICENSE] for the full details.

## Contributing

[PRs] and [issues] are welcome!

---

[DSL]: https://en.wikipedia.org/wiki/Domain-specific_language
[EBNF]: https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_form
[AST]: https://en.wikipedia.org/wiki/Abstract_syntax_tree
[parse tree]: https://en.wikipedia.org/wiki/Parse_tree
[PEG]: https://en.wikipedia.org/wiki/Parsing_expression_grammar
[License]: ./docs/LICENSE.md
[PRs]: https://github.com/stone-lang/grammy/pulls
[issues]: https://github.com/stone-lang/grammy/issues
