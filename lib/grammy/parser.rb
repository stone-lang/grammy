require "grammy"
require "grammy/scanner"

module Grammy

  def self.Parser(grammar_class) = Parser.new(grammar_class)

  class Parser

    def initialize(grammar_class)
      @grammar_class = grammar_class
    end

    def parse(input)
      scanner = Grammy::Scanner.new(input)
      grammar = @grammar_class.new(scanner)
      result = grammar.instance_exec(&grammar.rules[grammar.start])
      fail(Grammy::ParseError, "Parsing failed at position #{scanner.pos}") unless result && scanner.pos == scanner.input.size
      result
    end

  end

end
