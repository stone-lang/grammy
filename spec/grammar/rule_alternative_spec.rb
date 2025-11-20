require "grammy/grammar"

# Test using rule references (not terminals) with the | operator
# rubocop:disable RSpec/DescribeClass
RSpec.describe "Alternative with rule references", :integration do
  subject(:parse_tree) { grammar.parse(input) }

  let(:grammar) { RuleAlternativeGrammar }

  context "when parsing a number" do
    let(:input) { "42" }

    it "matches via the primary rule" do
      expect(parse_tree).not_to be_nil
      expect(parse_tree.name).to eq(:primary)
    end
  end

  context "when parsing an identifier" do
    let(:input) { "foo" }

    it "matches via the primary rule" do
      expect(parse_tree).not_to be_nil
      expect(parse_tree.name).to eq(:primary)
    end
  end
end

class RuleAlternativeGrammar < Grammy::Grammar
  start :primary

  rule(:primary) { literal | reference }
  rule(:literal) { number }
  rule(:reference) { identifier }

  terminal(:number, /\d+/)
  terminal(:identifier, /[a-z]+/)
end
# rubocop:enable RSpec/DescribeClass
