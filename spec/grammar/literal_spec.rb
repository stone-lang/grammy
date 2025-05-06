require "grammy/grammar"

class LiteralGrammar < Grammy::Grammar
  root(:plus)
  rule(:plus) { match("+") }
end

RSpec.describe LiteralGrammar do
  subject(:parse_tree) { grammar.parse(input) }
  let(:grammar) { described_class }
  let(:tokens) { parse_tree.tokens.map(&:to_s) }

  context "with a literal `+`" do
    let(:input) { "+" }

    it "parses" do
      expect(tokens).to eq(["+"])
    end

    it "parses and returns the parse tree" do
      expect(parse_tree).to be_a(Grammy::ParseTree)
      expect(parse_tree.name).to eq("plus")
    end
  end

  context "with anything other than a literal `+`" do
    let(:input) { "-" }

    it "raises an error" do
      expect { tokens }.to raise_error(Grammy::ParseError)
    end
  end
end
