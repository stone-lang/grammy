require "grammy/grammar"
require "timeout"

# rubocop:disable RSpec/DescribeMethod
RSpec.describe Grammy::Grammar, "rule recursion" do
  subject(:parse_result) { grammar.parse(input) }
  let(:tokens) { parse_result.tokens.map(&:to_s) }

  context "with simple recursion through user-defined combinator" do
    let(:grammar) { SimpleRecursionGrammar }

    context "with single level parentheses" do
      let(:input) { "(5)" }

      it "parses through the combinator" do
        expect(tokens).to eq(["(", "5", ")"])
      end
    end
  end

  context "with left recursion" do
    let(:grammar) { LeftRecursionGrammar }
    let(:input) { "aaa" }

    it "causes stack overflow (expected limitation of PEG parsers)" do
      # Left recursion causes infinite loop/stack overflow in PEG parsers
      # This is a known limitation that would require special handling (future work)
      expect {
        Timeout.timeout(1) { parse_result }
      }.to raise_error(SystemStackError)
    end
  end

end


# Simple case: user-defined combinator wrapping a rule (non-recursive)
class SimpleRecursionGrammar < Grammy::Grammar
  start :expr
  rule(:expr) { parens(number) }
  rule(:number) { reg(/\d+/) }

  def parens(exp) = str("(") + exp + str(")")
end


# Left recursion (problematic - causes stack overflow)
class LeftRecursionGrammar < Grammy::Grammar
  start :expr
  rule(:expr) { expr + str("a") | str("a") }
end
# rubocop:enable RSpec/DescribeMethod
