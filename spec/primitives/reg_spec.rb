RSpec.describe Grammy::Grammar, "#reg" do
  subject(:grammar) {
    Class.new(described_class) do
      start(:start)
      rule(:start) { reg(/a.c/) }
    end
  }

  let(:parse_tree) { grammar.parse(input) }
  let(:tokens) { parse_tree.tokens.map(&:text) }

  it "matches a string with a pattern" do
    expect(grammar.parse("abc")).to be_truthy
    expect(grammar.parse("axc")).to be_truthy
  end

  it "does not match a string that does not fit the pattern" do
    expect{ grammar.parse("ac") }.to raise_error(Grammy::ParseError)
    expect{ grammar.parse("abbc") }.to raise_error(Grammy::ParseError)
  end
end
