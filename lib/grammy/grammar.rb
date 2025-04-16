require "grammy/combinator/primitives"
require "grammy/scanner"
require "grammy/matcher"
require "grammy/errors"
require "grammy/parse_tree"


module Grammy
  class Grammar

    include Grammy::Combinator::Primitives

    class << self
      # DSL for defining grammar rules.
      def root(rule_name) = @root_rule = rule_name
      def rule(name, &)
        rules[name] = lambda { |_|
          results = instance_eval(&)
          children = Array(results).flatten.map { |result|
            result.is_a?(Grammy::Matcher) ? result.match(@scanner) : result
          }
          Grammy::ParseTree.new(name.to_s, children.flatten)
        }
      end

      # Access to the rules.
      def root_rule = @root_rule || :start
      def rules = @rules ||= {}
    end

    # Primitive combinators will need access to the scanner.
    def initialize(scanner) = @scanner = scanner

    def execute_rule(rule_name) = instance_eval(&rules[rule_name])
    def rules = self.class.rules

  end
end
