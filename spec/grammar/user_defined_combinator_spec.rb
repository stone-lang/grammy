require "grammy/grammar"


RSpec.describe Grammy::Grammar, :integration do
  subject(:parse_result) { grammar.parse(input) }
  let(:tokens) { parse_result.tokens.map(&:to_s) }
  let(:parse_tree) { parse_result.parse_tree }

  context "with a user-defined combinator" do
    let(:grammar) { UserDefinedGrammar }

    context "with a valid input" do
      let(:input) { "(123)" }
      let(:expected_tokens) { ["(", "123", ")"] }

      it "parses and returns the parse tree" do
        expect(tokens).to eq(expected_tokens)
      end
    end
  end

end


class UserDefinedGrammar < Grammy::Grammar
  start :us
  rule(:us) { parens(number) }
  terminal(:number, /\d+/)

  # User-defined combinator that wraps an expression in parentheses
  def parens(exp) = str("(") + exp + str(")")
end
