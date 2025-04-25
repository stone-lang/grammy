require "grammy/grammar"

class AltGrammar < Grammy::Grammar
  root(:greeting)
  rule(:greeting) { alt(match("hello"), match("hi"), match("hey")) }
end

RSpec.describe AltGrammar do
  subject(:parse_tree) { grammar.parse(input) }
  let(:grammar) { described_class }
  let(:tokens) { parse_tree.tokens }

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
