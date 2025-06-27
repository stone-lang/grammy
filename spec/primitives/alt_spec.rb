RSpec.describe Grammy::Grammar, "#alt" do
  subject(:grammar) {
    Class.new(described_class) do
      root(:greeting)
      rule(:greeting) { alt(str("hello"), str("hi"), str("hey")) }
    end
  }

  let(:parse_tree) { grammar.parse(input) }
  let(:tokens) { parse_tree.tokens.map(&:text) }

  context "with the first alternative" do
    let(:input) { "hello" }

    it "parses" do
      expect(tokens).to eq(["hello"])
    end

    it "parses and returns the parse tree" do
      expect(parse_tree).to be_a(Grammy::ParseTree)
      expect(parse_tree.name).to eq("greeting")
    end
  end

  context "with the second alternative" do
    let(:input) { "hi" }

    it "parses" do
      expect(tokens).to eq(["hi"])
    end

    it "parses and returns the parse tree" do
      expect(parse_tree).to be_a(Grammy::ParseTree)
      expect(parse_tree.name).to eq("greeting")
    end
  end

  context "with the third alternative" do
    let(:input) { "hey" }

    it "parses" do
      expect(tokens).to eq(["hey"])
    end

    it "parses and returns the parse tree" do
      expect(parse_tree).to be_a(Grammy::ParseTree)
      expect(parse_tree.name).to eq("greeting")
    end
  end

  context "with an invalid alternative" do
    let(:input) { "howdy" }

    it "raises an error" do
      expect { tokens }.to raise_error(Grammy::ParseError)
    end
  end
end
