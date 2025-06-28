RSpec.describe Grammy::Grammar, "#eol" do
  subject(:grammar) {
    Class.new(described_class) do
      root(:two_lines)
      rule(:two_lines) { str("abc") + eol + str("def") }
    end
  }

  let(:parse_tree) { grammar.parse(input) }
  let(:tokens) { parse_tree.tokens.map(&:text) }

  context "with a newline" do
    let(:input) { "abc\ndef" }

    it "parses the string" do
      expect(tokens).to eq(["abc", "\n", "def"])
    end
  end

  context "with a carriage return and a newline" do
    let(:input) { "abc\r\ndef" }

    it "parses the string" do
      expect(tokens).to eq(["abc", "\r\n", "def"])
    end
  end
end
