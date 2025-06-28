RSpec.describe Grammy::Grammar, "#str" do
  subject(:grammar) {
    Class.new(described_class) do
      start(:greeting)
      rule(:greeting) { str("hello") }
    end
  }

  let(:parse_tree) { grammar.parse(input) }
  let(:tokens) { parse_tree.tokens.map(&:text) }

  context "with exact match" do
    let(:input) { "hello" }

    it "parses the string" do
      expect(tokens).to eq(["hello"])
    end
  end

  context "with non-matching input" do
    let(:input) { "hi" }

    it "raises an error" do
      expect { tokens }.to raise_error(Grammy::ParseError)
    end
  end
end
