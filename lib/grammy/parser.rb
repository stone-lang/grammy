require "grammy/errors"
require "grammy/scanner"
require "grammy/parse_result"


# Technically, the parser combinators are parsers themselves.
# This is just a method object to combine all the various moving parts.
module Grammy
  class Parser

    def initialize(grammar_class, input, start_rule)
      @start_rule = start_rule
      @scanner = Grammy::Scanner.new(input)
      @grammar_class = grammar_class
      @grammar = grammar_class.new(@scanner)
    end

    def parse
      result = @grammar.execute_rule(@start_rule)
      fail(Grammy::ParseError, "Parsing failed at position #{@scanner.position}") if @start_rule == @grammar_class.root_rule && !@scanner.finished?
      fail(Grammy::ParseError, "Parsing failed at position #{@scanner.position}") if result.nil? || result.empty? && !@scanner.input.empty?
      Grammy::ParseResult.new(result)
    end

  end
end
