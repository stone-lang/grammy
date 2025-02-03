# Grammy

## Intro

Grammy is a simple parser.
You define the the language to parse with a grammar.
The grammar is written in a simple BNF-like format.
Grammy implementats a PEG (Parsing Expression Grammar) parser.
But that's an implementation detail, possibly subject to change,
if something better comes along (LPEG, GLR, etc).

You can use Grammy to parse complex languages.
I'm going to be using it to write a full general-purpose programming language.
But you can also use it to parse simpler languages, like:

- JSON
- CSV
- external DSLs
- configuration files
- data formats
- HTTP headers

Basically, if you have a BNF grammar,
you can easily use Grammy to parse it.

Grammy is basically a DSL for generating a parser.
You describe the grammar in a Ruby DSL.
Grammy dynamically generates a parser from that description.
You can then use the parser to parse strings.

## Usage

~~~ ruby
require 'grammy'

class Arithmetic < Grammy::Grammar
  # Specify which rule to start with.
  start :expression

  # Define the rules.
  rule(:expression) { term + (match("+") + term)[0..] }
  rule(:term) { factor + (match("*") + factor)[0..] }
  rule(:factor) { number | parens(expression) }
  rule(:number) { match(/\d+/) }

  # Define any custom combinators.
  def parens(exp) = match("(") + expression + match(")")
end

parser = Grammy::Parser(Arithmetic)
input = "2+3"
parse_tree = parser.parse(input)
parse_tree.to_s == {
  expression: {
    term: [
      {
        factor: [
          {
            number: [
              "2"
            ]
          }
        ]
      },
      {
        factor: [
          {
            number: [
              "3"
            ]
          }
        ]
      }
    ]
  }
}
expect(parse_tree).to eq(expected_parse_tree)

~~~

## Tests

~~~ shell
rspec
~~~
