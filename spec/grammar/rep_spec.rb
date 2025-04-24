require "grammy/grammar"

class ZeroOrMoreGrammar < Grammy::Grammar
  root(:digits)
  rule(:digits) { rep(match(/[0-9]/), 0..) }
end

class OneOrMoreGrammar < Grammy::Grammar
  root(:digits)
  rule(:digits) { rep(match(/[0-9]/), 1..) }
end

class OptionalGrammar < Grammy::Grammar
  root(:digits_then_a)
  rule(:digits_then_a) { seq(rep(match(/[0-9]/), 0..1), match("a")) }
end

RSpec.describe Grammy::Matcher::Repetition do
  subject(:parse_result) { grammar.parse(input) }
  let(:tokens) { parse_result.tokens }
  let(:parse_tree) { parse_result.parse_tree }

  describe ZeroOrMoreGrammar do
    let(:grammar) { described_class }

    context "with multiple digits" do
      let(:input) { "12345" }

      it "parses all digits" do
        expect(tokens).to eq(["1", "2", "3", "4", "5"])
      end

      it "includes all matches in the parse tree" do
        expect(parse_tree).to be_a(Grammy::ParseTree)
        expect(parse_tree.name).to eq("digits")
      end
    end

    context "with a single digit" do
      let(:input) { "7" }

      it "parses the digit" do
        expect(tokens).to eq(["7"])
      end

      it "includes the match in the parse tree" do
        expect(parse_tree).to be_a(Grammy::ParseTree)
        expect(parse_tree.name).to eq("digits")
      end
    end

    context "with zero digits" do
      let(:input) { "" }

      it "parses successfully with no tokens" do
        expect(tokens).to eq([])
      end

      it "returns an empty parse tree" do
        expect(parse_tree).to be_a(Grammy::ParseTree)
        expect(parse_tree.name).to eq("digits")
        expect(parse_tree.children).to be_empty
      end
    end

    context "with non-matching input" do
      let(:input) { "abc" }

      it "raises an error" do
        expect { tokens }.to raise_error(Grammy::ParseError)
      end
    end
  end

  describe OneOrMoreGrammar do
    let(:grammar) { described_class }

    context "with multiple digits" do
      let(:input) { "12345" }

      it "parses all digits" do
        expect(tokens).to eq(["1", "2", "3", "4", "5"])
      end

      it "includes all matches in the parse tree" do
        expect(parse_tree).to be_a(Grammy::ParseTree)
        expect(parse_tree.name).to eq("digits")
        expect(parse_tree.children.size).to eq(5)
      end
    end

    context "with a single digit" do
      let(:input) { "7" }

      it "parses the digit" do
        expect(tokens).to eq(["7"])
      end

      it "includes the match in the parse tree" do
        expect(parse_tree).to be_a(Grammy::ParseTree)
        expect(parse_tree.name).to eq("digits")
        expect(parse_tree.children.size).to eq(1)
      end
    end

    context "with non-matching input" do
      let(:input) { "abc" }

      it "raises an error" do
        expect { tokens }.to raise_error(Grammy::ParseError)
      end
    end
  end

  describe OptionalGrammar do
    let(:grammar) { described_class }

    context "with a single digit" do
      let(:input) { "7a" }

      it "parses the digit" do
        expect(tokens).to eq(["7", "a"])
      end

      it "includes the match in the parse tree" do
        expect(parse_tree).to be_a(Grammy::ParseTree)
        expect(parse_tree.name).to eq("digits_then_a")
      end
    end

    context "with multiple digits" do
      let(:input) { "12a" }

      it "does not match a 2nd digit" do
        expect{ parse_tree }.to raise_error(Grammy::ParseError)
      end
    end

    context "with zero digits" do
      let(:input) { "a" }

      it "parses successfully with no tokens" do
        expect(tokens).to eq(["a"])
      end

      it "returns an empty parse tree" do
        expect(parse_tree).to be_a(Grammy::ParseTree)
        expect(parse_tree.name).to eq("digits_then_a")
      end
    end

  end
end
