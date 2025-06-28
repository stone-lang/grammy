RSpec.describe Grammy::Grammar, "#wsp" do
  subject(:grammar) {
    Class.new(described_class) do
      start(:two_lines)
      rule(:two_lines) { str("abc") + wsp + str("def") }
    end
  }

  let(:parse_tree) { grammar.parse(input) }
  let(:tokens) { parse_tree.tokens.map(&:text) }

  context "with some spaces" do
    let(:input) { "abc     def" }

    it "parses the string" do
      expect(tokens).to eq(["abc", "     ", "def"])
    end
  end

  context "with tabs and spaces" do
    let(:input) { "abc \t\t def" }

    it "parses the string" do
      expect(tokens).to eq(["abc", " \t\t ", "def"])
    end
  end

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

  context "with the kitchen sink" do
    let(:input) { "abc \r\n \t  def" }

    it "parses the string" do
      expect(tokens).to eq(["abc", " \r\n \t  ", "def"])
    end
  end
end
