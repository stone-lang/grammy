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

class ChoiceGrammar < Grammy::Grammar
  start :cho
  rule(:cho) { choice(match("x"), match("y")) }
end

class RefinedSequenceGrammar < Grammy::Grammar
  using Grammy::Refinements
  start :seq
  rule(:seq) { "x = " + /\d+/ }
end

class RefinedChoiceGrammar < Grammy::Grammar
  using Grammy::Refinements
  start :cho
  rule(:cho) { "x" | "y" }
end

class SequenceAndChoiceGrammar < Grammy::Grammar
  using Grammy::Refinements
  start :sc
  rule(:sc) { "x = " + /\d+/ | "y" }
end

class ChoiceAndSequenceGrammar < Grammy::Grammar
  using Grammy::Refinements
  start :cs
  rule(:cs) { "x" + ("y" | "z") }
end

class UserDefinedGrammar < Grammy::Grammar
  start :us
  rule(:us) { parens(match("123")) }
  rule(:number) { match(/\d+/) }
  def parens(exp) = match("(") + exp + match(")")
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

  context "with a grammar with a sequence using `+`" do
    let(:grammar) { RefinedSequenceGrammar }

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

  context "with a grammar with a choice" do
    let(:grammar) { ChoiceGrammar }

    context "with a valid input" do
      let(:input) { "x" }
      let(:expected_parse_tree) { "x" }

      it "parses and returns the parse tree" do
        expect(parse_tree).to eq(expected_parse_tree)
      end
    end

    context "with an invalid input" do
      let(:input) { "z" }

      it "raises an error" do
        expect { parse_tree }.to raise_error(Grammy::ParseError)
      end
    end
  end

  context "with a grammar with a choice using `|`" do
    let(:grammar) { RefinedChoiceGrammar }

    context "with a valid input" do
      let(:input) { "x" }
      let(:expected_parse_tree) { "x" }

      it "parses and returns the parse tree" do
        expect(parse_tree).to eq(expected_parse_tree)
      end
    end

    context "with an invalid input" do
      let(:input) { "z" }

      it "raises an error" do
        expect { parse_tree }.to raise_error(Grammy::ParseError)
      end
    end
  end

  context "with a grammar with a choice and a sequence" do
    let(:grammar) { SequenceAndChoiceGrammar }

    context "when the input matches the first choice" do
      let(:input) { "x = 1234" }
      let(:expected_parse_tree) { ["x = ", "1234"] }

      it "parses and returns the parse tree" do
        expect(parse_tree).to eq(expected_parse_tree)
      end
    end

    context "when the input matches the second choice" do
      let(:input) { "y" }
      let(:expected_parse_tree) { "y" }

      it "parses and returns the parse tree" do
        expect(parse_tree).to eq(expected_parse_tree)
      end
    end
  end

  context "with a grammar with a choice and a sequence with parentheses" do
    let(:grammar) { ChoiceAndSequenceGrammar }

    context "when the input matches the first choice" do
      let(:input) { "xy" }
      let(:expected_parse_tree) { ["x", "y"] }

      it "parses and returns the parse tree" do
        expect(parse_tree).to eq(expected_parse_tree)
      end
    end

    context "when the input matches the second choice" do
      let(:input) { "xz" }
      let(:expected_parse_tree) { ["x", "z"] }

      it "parses and returns the parse tree" do
        expect(parse_tree).to eq(expected_parse_tree)
      end
    end
  end

  context "with a user-defined combinator" do
    let(:grammar) { UserDefinedGrammar }

    context "with a valid input" do
      let(:input) { "(123)" }
      let(:expected_parse_tree) { ["(", "123", ")"] }

      it "parses and returns the parse tree" do
        parse_tree = parser.parse(input)
        expect(parse_tree).to eq(expected_parse_tree)
      end
    end
  end

end
