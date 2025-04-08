require "grammy/combinator/primitives"


module Grammy
  class Grammar

    extend Grammy::Combinator::Primitives

    class << self
      # DSL for defining grammar rules.
      def root(rule_name) = @root_rule = rule_name
      def rule(name, &block) = rules[name] = block

      # Access to the rules. NOTE: `root_rule` returns the rule *name*.
      def root_rule = @root_rule || :start
      def rules = @rules ||= {}
    end

    # Primitive combinators will need access to the scanner.
    def initialize(scanner) = @scanner = scanner

    # Allow the parser to get the rules' body/block/proc.
    def root_rule = self.class.rules[self.class.root_rule]
    def rule(name) = self.class.rules[name]

  end
end
