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
  def parens(exp) = match("(") + exp + match(")")
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

## Class Hierarchy (actually, dependency graph)

grammar = ArithmeticGrammar
parser = PEG::Parser(grammar)
ast_module = Stone::AST
language = Language(parser, grammar, ast_module)
input = File::Source("example.stone")
input = "2+3*(4+5)"
program = Program(language, input)
parse_tree = program.parse_tree

- `Grammar`
    - has_many `Rule`
- `Parser`
    - has_a `Grammar`
- `Language`
    - has_a `Parser`
    - has_a `Grammar`
    - has_an `ASTModule` # module with classes for AST nodes

~~~ ruby
# I want to test that we have the correct parse tree,
# given a grammar and an input String.

# So my test of a grammar will need an input.

class Rule < BetterData.define(
    has_a: {
        name: Symbol,
        body: Proc
    }
)



class Grammar < BetterData.define(
    extends: Combinators,
    has_many: {
        rules: Rule,
        custom_combinators: Proc,
        terminals: Symbol
    },
    has_a: {
        start_rule: Rule
    },
    uses: {
        input: String
    }
)

class ParseTree < BetterData.define(
    has_a: {
        root_node: Node
    }
)

grammar = ArithmeticGrammar
parser = Parser(grammar)
ast_module = Stone::AST
language = Language(parser, grammar, ast_module)
input = File::Source("example.stone")
input = "2+3*(4+5)"
program = Program(language, input)
parse_tree = program.parse_tree


require "language"
require "input"
# This is actually a "compilation unit".
class Program < BetterData.define(
    has_a: {
        language: Language,
        input: String | File::Source
    },
    computes: {
        filename: -> { input.responds_to?(:filename) ? input.filename : "REPL" },
        parse_tree: -> { language.parser.parse(input) },
        executable: -> { language.compile(llir).tap { llir.delete unless filename.extname == '.ll'} },
        llir: -> { ast.to_llir },
        ast: -> { parse_tree.to_ast }

    }
)
program = Program(language:, input:)
program.parse_tree

class Parser < BetterData.define(
    has_a: {
        grammar: Grammar
    }
)

class Language < BetterData.define(
    has_a: {
        parser: Parser,
        grammar: Grammar,
        ast_module: Module
    }
)
language = Language(parser:, grammar:, ast_module:)

~~~
