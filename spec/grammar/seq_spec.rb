require "grammy/grammar"

class SeqGrammar < Grammy::Grammar
  root(:greeting)
  rule(:greeting) { seq(str("hello"), str(" "), str("world")) }
end

RSpec.describe SeqGrammar do
  subject(:parse_tree) { grammar.parse(input) }
  let(:grammar) { described_class }
  let(:tokens) { parse_tree.tokens.map(&:text) }

  context "with a valid sequence" do
    let(:input) { "hello world" }

    it "parses" do
      expect(tokens).to eq(["hello", " ", "world"])
    end

    it "parses and returns the parse tree" do
      expect(parse_tree).to be_a(Grammy::ParseTree)
      expect(parse_tree.name).to eq("greeting")
    end
  end

  context "with an invalid sequence" do
    let(:input) { "hello moon" }

    it "raises an error" do
      expect { tokens }.to raise_error(Grammy::ParseError)
    end
  end

  context "with a partial match" do
    let(:input) { "hello " }

    it "raises an error" do
      expect { tokens }.to raise_error(Grammy::ParseError)
    end
  end
end
