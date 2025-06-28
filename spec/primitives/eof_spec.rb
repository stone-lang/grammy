RSpec.describe Grammy::Grammar, "#eof" do
  subject(:grammar) {
    Class.new(described_class) do
      start(:one_line)
      rule(:one_line) { str("abc") + eof }
    end
  }

  let(:parse_tree) { grammar.parse(input) }
  let(:tokens) { parse_tree.tokens.map(&:text) }

  context "with the string at the end of the file" do
    let(:input) { "abc" }

    it "parses the string" do
      expect(tokens).to eq(["abc"])
    end
  end

  context "with the string NOT at the end of the file" do
    let(:input) { "abcx" }

    it "fails to parse" do
      expect{ tokens }.to raise_error(Grammy::ParseError)
    end
  end
end
