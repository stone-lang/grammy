require "grammy/grammar"


RSpec.describe Grammy::Grammar, :integration do
  subject(:parse_tree) { grammar.parse(input) }
  let(:tokens) { parse_tree.tokens }

  context "with a grammar with a sequence using `+`" do
    let(:grammar) { DslGrammars::Sequence }

    context "with a valid input" do
      let(:input) { "x = 1234" }
      let(:expected_tokens) { ["x = ", "1234"] }

      it "parses and returns the parse tree" do
        expect(tokens.map(&:to_s)).to eq(expected_tokens)
      end
    end

    context "with an invalid input" do
      let(:input) { "x=1234" }

      it "raises an error" do
        expect { parse_tree }.to raise_error(Grammy::ParseError)
      end
    end
  end

  context "with a grammar with alternatives using `|`" do
    let(:grammar) { DslGrammars::Choice }

    context "with a valid input" do
      let(:input) { "x" }
      let(:expected_tokens) { ["x"] }

      it "parses and returns the parse tree" do
        expect(tokens.map(&:to_s)).to eq(expected_tokens)
      end
    end

    context "with an invalid input" do
      let(:input) { "z" }

      it "raises an error" do
        expect { tokens }.to raise_error(Grammy::ParseError)
      end
    end
  end

  context "with a grammar with a choice and a sequence" do
    let(:grammar) { DslGrammars::SequenceAndChoice }

    context "when the input matches the first choice" do
      let(:input) { "x = 1234" }
      let(:expected_tokens) { ["x = ", "1234"] }

      it "parses and returns the parse tree" do
        expect(tokens.map(&:to_s)).to eq(expected_tokens)
      end
    end

    context "when the input matches the second choice" do
      let(:input) { "y" }
      let(:expected_tokens) { ["y"] }

      it "parses and returns the parse tree" do
        expect(tokens.map(&:to_s)).to eq(expected_tokens)
      end
    end
  end

  context "with a grammar with a choice and a sequence with parentheses" do
    let(:grammar) { DslGrammars::ChoiceAndSequence }

    context "when the input matches the first choice" do
      let(:input) { "xy" }
      let(:expected_tokens) { ["x", "y"] }

      it "parses and returns the parse tree" do
        expect(tokens.map(&:to_s)).to eq(expected_tokens)
      end
    end

    context "when the input matches the second choice" do
      let(:input) { "xz" }
      let(:expected_tokens) { ["x", "z"] }

      it "parses and returns the parse tree" do
        expect(tokens.map(&:to_s)).to eq(expected_tokens)
      end
    end
  end

  context "with a grammar using the repetition operator `[x..y]`" do
    let(:grammar) { DslGrammars::Repetition }

    context "with zero or more repetitions" do
      let(:input) { "aaaaa" }
      let(:expected_tokens) { ["a", "a", "a", "a", "a"] }

      it "parses and returns all matches" do
        expect(tokens.map(&:to_s)).to eq(expected_tokens)
      end
    end

    context "with no repetitions" do
      let(:input) { "" }
      let(:expected_tokens) { [] }

      it "parses successfully with no tokens" do
        expect(tokens.map(&:to_s)).to eq(expected_tokens)
      end
    end
  end

  context "with a grammar using the repetition operator with exact range" do
    let(:grammar) { DslGrammars::ExactRangeRepetition }

    context "with a valid number of repetitions" do
      let(:input) { "aaa" }
      let(:expected_tokens) { ["a", "a", "a"] }

      it "parses and returns all matches" do
        expect(tokens.map(&:to_s)).to eq(expected_tokens)
      end
    end

    context "with too few repetitions" do
      let(:input) { "aa" }

      it "raises an error" do
        expect { tokens }.to raise_error(Grammy::ParseError)
      end
    end

    context "with too many characters" do
      let(:input) { "aaaa" }

      it "parses only the required number" do
        expect(tokens.map(&:to_s)).to eq(["a", "a", "a"])
        # NOTE: The scanner will have 1 more character left.
      end
    end
  end

  context "with a grammar using repetition in sequence" do
    let(:grammar) { DslGrammars::RepetitionSequence }

    context "with valid repetitions in a sequence" do
      let(:input) { "aaabbb" }
      let(:expected_tokens) { ["a", "a", "a", "b", "b", "b"] }

      it "parses and returns all matches" do
        expect(tokens.map(&:to_s)).to eq(expected_tokens)
      end
    end

    context "with invalid repetitions" do
      let(:input) { "aabb" }

      it "raises an error" do
        expect { tokens }.to raise_error(Grammy::ParseError)
      end
    end
  end

  context "with a grammar using repetition with alternation" do
    let(:grammar) { DslGrammars::RepetitionAlternation }

    context "with the first alternative repeated" do
      let(:input) { "aaa" }
      let(:expected_tokens) { ["a", "a", "a"] }

      it "parses and returns all matches" do
        expect(tokens.map(&:to_s)).to eq(expected_tokens)
      end
    end

    context "with the second alternative repeated" do
      let(:input) { "bbb" }
      let(:expected_tokens) { ["b", "b", "b"] }

      it "parses and returns all matches" do
        expect(tokens.map(&:to_s)).to eq(expected_tokens)
      end
    end

    context "with mixed alternatives" do
      let(:input) { "aba" }

      let(:expected_tokens) { ["a", "b", "a"] }

      it "parses and returns all matches" do
        expect(tokens.map(&:to_s)).to eq(expected_tokens)
      end
    end
  end

  context "with a grammar using repetition with parenthesized alternation" do
    let(:grammar) { DslGrammars::RepetitionGroupedAlternation }

    context "with repeated first alternatives" do
      let(:input) { "aba" }
      let(:expected_tokens) { ["a", "b", "a"] }

      it "parses and returns all matches" do
        expect(tokens.map(&:to_s)).to eq(expected_tokens)
      end
    end

    context "with repeated second alternatives" do
      let(:input) { "bab" }
      let(:expected_tokens) { ["b", "a", "b"] }

      it "parses and returns all matches" do
        expect(tokens.map(&:to_s)).to eq(expected_tokens)
      end
    end
  end

  context "with an optional syntax using [0..1]" do
    let(:grammar) { DslGrammars::Optional }

    context "with the optional element present" do
      let(:input) { "ab" }
      let(:expected_tokens) { ["a", "b"] }

      it "parses and returns all matches 230" do
        expect(tokens.map(&:to_s)).to eq(expected_tokens)
      end
    end

    context "with the optional element absent" do
      let(:input) { "aa" }
      let(:expected_tokens) { ["a"] }

      it "parses and returns just the required match" do
        expect(tokens.map(&:to_s)).to eq(expected_tokens)
        # NOTE: The scanner will have 1 more character left.
      end
    end
  end

end


module DslGrammars
  class Sequence < Grammy::Grammar
    start :seq
    rule(:seq) { str("x = ") + reg(/\d+/) }
  end

  class Choice < Grammy::Grammar
    start :cho
    rule(:cho) { str("x") | str("y") }
  end

  class SequenceAndChoice < Grammy::Grammar
    start :sc
    rule(:sc) { str("x = ") + reg(/\d+/) | str("y") }
  end

  class ChoiceAndSequence < Grammy::Grammar
    start :cs
    rule(:cs) { str("x") + (str("y") | str("z")) }
  end

  class Repetition < Grammy::Grammar
    start :rep
    rule(:rep) { str("a")[0..] }
  end

  class ExactRangeRepetition < Grammy::Grammar
    start :rep
    rule(:rep) { str("a")[3..3] }
  end

  class RepetitionSequence < Grammy::Grammar
    start :rep_seq
    rule(:rep_seq) { str("a")[3..3] + str("b")[3..3] }
  end

  class RepetitionAlternation < Grammy::Grammar
    start :rep_alt
    rule(:rep_alt) { (str("a") | str("b"))[3..3] }
  end

  class RepetitionGroupedAlternation < Grammy::Grammar
    start :rep_group_alt
    rule(:rep_group_alt) { (str("a") | str("b"))[1..1] + (str("a") | str("b"))[1..1] + (str("a") | str("b"))[1..1] }
  end

  class Optional < Grammy::Grammar
    start :opt
    rule(:opt) { str("a") + str("b")[0..1] }
  end
end
