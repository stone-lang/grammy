RSpec.describe Grammy::Grammar, "#sof" do
  subject(:grammar) {
    Class.new(described_class) do
      root(:start)
      rule(:start) { sof + str("abc") }
    end
  }

  let(:parse_tree) { grammar.parse(input) }
  let(:tokens) { parse_tree.tokens.map(&:text) }

  context "with the string at the beginning of the file" do
    let(:input) { "abc" }

    it "parses the string" do
      expect(tokens).to eq(["abc"])
    end
  end

  context "with the string NOT at the beginning of the file" do
    let(:input) { "xabc" }

    it "fails to parse" do
      expect{ tokens }.to raise_error(Grammy::ParseError)
    end
  end

end
