RSpec.describe Grammy::Grammar, "#sol" do
  subject(:grammar) {
    Class.new(described_class) do
      start(:two_lines)
      rule(:two_lines) { str("abc\n") + sol + str("def") }
    end
  }

  let(:parse_tree) { grammar.parse(input) }
  let(:tokens) { parse_tree.tokens.map(&:text) }

  context "with a newline" do
    let(:input) { "abc\ndef" }

    it "parses the string" do
      expect(tokens).to eq(["abc\n", "def"])
    end
  end
end
