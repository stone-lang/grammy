require "grammy/matcher"


module Grammy
  class Matcher
    class Rule < Matcher

      def initialize(grammar, rule_name)
        @grammar = grammar
        @rule_name = rule_name
      end

      def match(scanner)
        # Execute the rule's block when match is called
        rule_block = @grammar.class.rules[@rule_name]
        fail Grammy::GrammarError, "No rule found for #{@rule_name}" unless rule_block

        # Evaluate the rule block in the grammar's context
        result = @grammar.instance_eval(&rule_block)

        # If the result is a matcher, match it to get actual results
        result = result.match(scanner) if result.is_a?(Grammy::Matcher)

        # Return nil if there's no match (don't create empty ParseTree nodes for failures)
        return nil if result.nil?

        # Wrap results in a ParseTree
        children = Array.wrap(result).flatten
        Grammy::ParseTree.new(@rule_name, children)
      end

    end
  end
end
