require "spec_helper"
require "debug"
require "grammy/grammar"
require "grammy/parser"

class LiteralGrammar < Grammy::Grammar
  start(:plus)
  rule(:plus) { match("+") }
end

class RegexGrammar < Grammy::Grammar
  start(:number)
  rule(:number) { match(/\d+/) }
end

class SequenceGrammar < Grammy::Grammar
  start :seq
  rule(:seq) { sequence(match("x = "), match(/\d+/)) }
end

RSpec.describe Grammy::Parser, :integration do
  subject(:parse_tree) { parser.parse(input) }
  let(:parser) { Grammy::Parser(grammar) }

  context "with a grammar looking for a literal plus sign (+)" do
    let(:grammar) { LiteralGrammar }

    context "with a literal `+`" do
      let(:input) { "+" }

      it "parses" do
        expect(parse_tree).to eq("+")
      end
    end

    context "with anything other than a literal `+`" do
      let(:input) { "-" }

      it "raises an error" do
        expect { parse_tree }.to raise_error(Grammy::ParseError)
      end
    end
  end

  context "with a regex grammar for a number" do
    let(:grammar) { RegexGrammar }

    context "with a valid number" do
      let(:input) { "123" }

      it "parses a number" do
        expect(parse_tree).to eq("123")
      end
    end

    context "with an invalid number" do
      let(:input) { "-" }

      it "raises an error" do
        expect { parse_tree }.to raise_error(Grammy::ParseError)
      end
    end
  end

  context "with a grammar with a sequence" do
    let(:grammar) { SequenceGrammar }

    context "with a valid input" do
      let(:input) { "x = 1234" }
      let(:expected_parse_tree) { ["x = ", "1234"] }

      it "parses and returns the parse tree" do
        expect(parse_tree).to eq(expected_parse_tree)
      end
    end

    context "with an invalid input" do
      let(:input) { "x=1234" }

      it "raises an error" do
        expect { parse_tree }.to raise_error(Grammy::ParseError)
      end
    end
  end
end
