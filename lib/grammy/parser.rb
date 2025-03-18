require "grammy"
require "grammy/scanner"

module Grammy

  def self.Parser(grammar_class) = Parser.new(grammar_class)

  class Parser

    def initialize(grammar_class)
      @grammar_class = grammar_class
    end

    def parse(input)
      context = ParseContext.new(@grammar_class, input)
      context.parse
    end

  end

  class ParseContext
    attr_reader :scanner, :grammar

    def initialize(grammar_class, input)
      @scanner = Grammy::Scanner.new(input)
      @grammar = grammar_class.new
    end

    def parse
      unless result && scanner.pos == scanner.input.size
        debugger if ENV["DEBUG"]&.to_i == 1 # rubocop:disable Lint/Debugger
        fail(Grammy::ParseError, "Parsing failed at position #{scanner.pos}")
      end
      result
    end

    private def result
      @result ||= grammar.instance_exec(&grammar.start_rule)
      @result = @result.match(scanner) if @result.is_a?(Grammy::Combinators::Matcher)
      @result
    end
  end

end
