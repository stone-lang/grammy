require "grammy/combinator/primitives"
require "grammy/errors"
require "grammy/scanner"
require "grammy/parse_tree"
require "grammy/matcher/rule"
require_relative "../extensions/array"


module Grammy
  class Grammar

    include Grammy::Combinator::Primitives

    class << self
      # DSL for defining grammar rules.
      def start(rule_name) = @start_rule = rule_name
      def rule(name, &block)
        # Store the rule block for later execution
        rules[name] = block

        # Define a method that returns a RuleMatcher for composition
        define_method(name) { Grammy::Matcher::Rule.new(self, name) }
      end

      # Examples:
      #   terminal(:number, /\d+/)
      #   terminal(:number) { /\d+/ }
      #   terminal(:open_paren, "(")
      #   terminal(:open_paren) { "(" }
      def terminal(name, pattern = nil, &block)
        fail ArgumentError, "may only supply a pattern OR a block to #{__callee__}" if pattern && block
        pattern ||= yield if block
        if pattern.is_a?(Regexp)
          terminal_proc = -> { Grammy::Matcher::Regexp.new(pattern) }
        else
          terminal_proc = -> { Grammy::Matcher::String.new(pattern) }
        end
        define_method(name, &terminal_proc)
        rules[name] = terminal_proc
      end
      alias token terminal

      # Access to the rules.
      def start_rule = @start_rule || @rules.first || :start
      def rules = @rules ||= {}

      # Parse an input using the grammar.
      def parse(input, start: start_rule)
        scanner = Grammy::Scanner.new(input)
        grammar = self.new(scanner)
        result = grammar.execute_rule(start)
        fail(Grammy::ParseError, "Parsing failed at location #{scanner.location}") if result.nil? || result.empty? && !scanner.input.empty?
        result
      end
    end

    # Primitive combinators will need access to the scanner.
    def initialize(scanner) = @scanner = scanner

    def execute_rule(rule_name) = public_send(rule_name).match(@scanner)

    def rules = self.class.rules

  end
end
