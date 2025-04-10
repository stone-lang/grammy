require "grammy/grammar"
require "grammy/scanner"
require "grammy/match"


# rubocop:disable Naming/VariableNumber
RSpec.describe Grammy::Grammar do

  subject(:grammar) do
    Class.new(described_class) do
      root :greet
      rule(:greet) { "hello" }
    end
  end
  let(:scanner) { instance_double(Grammy::Scanner, match: nil) }
  let(:grammar_instance) { grammar.new(scanner) }

  describe ".root" do
    it "sets the root rule, for access via `.root_rule`" do
      expect(grammar.root_rule).to eq(:greet)
    end
  end

  describe ".rule" do
    it "stores the rule definition, for access via `.rules`" do
      expect(grammar.rules).to have_key(:greet)
    end
  end

  describe ".root_rule" do
    it "returns the name of the root rule" do
      expect(grammar.root_rule).to eq(:greet)
    end
  end

  describe "using primitive combinators in a rule" do

    let(:scanner) { Grammy::Scanner.new(input) }
    let(:input) { "abc123" }
    let(:match_result) { grammar_instance.execute_rule(rule).match(scanner) }

    context "with a `match` combinator" do

      before do
        grammar.class_eval do
          rule(:match1) { match("abc") }
        end
      end

      let(:rule) { :match1 }

      it "returns a Match matching the string" do
        expect(match_result).to be_a(Grammy::Match)
        expect(match_result.matched_string).to eq("abc")
      end
    end

    context "with a `seq` combinator" do

      before do
        grammar.class_eval do
          rule(:seq1) { seq(match("abc"), match("123")) }
        end
      end

      let(:rule) { :seq1 }

      it "returns a Match for each match of the string" do
        expect(match_result).to be_an(Array)
        expect(match_result.first.matched_string).to eq("abc")
        expect(match_result.last.matched_string).to eq("123")
      end
    end

    context "with an `alt` combinator" do

      before do
        grammar.class_eval do
          rule(:alt1) { alt(match(/\d+/), match("abc")) }
        end
      end

      let(:rule) { :alt1 }

      it "returns a Match with the matched pattern" do
        expect(match_result.matched_string).to eq("abc")
      end
    end

    context "with a `rep` combinator" do

      before do
        grammar.class_eval do
          rule(:rep0_1) { rep(match(/\d+x/), 0..1) }
          rule(:rep1_) { rep(match(/\d+x/), 1..) }
          rule(:rep0_) { rep(match("abc"), 0..) }
        end
      end

      let(:input) { "123x1234x54321xY" }

      it "allows 0 or 1 matches" do
        match_result = grammar_instance.execute_rule(:rep0_1).match(scanner)
        expect(match_result.map(&:matched_string)).to eq(["123x"])
      end

      it "allows 1 or more matches" do
        match_result = grammar_instance.execute_rule(:rep1_).match(scanner)
        expect(match_result.map(&:matched_string)).to eq(["123x", "1234x", "54321x"])
      end

      it "allows no matches" do
        match_result = grammar_instance.execute_rule(:rep0_).match(scanner)
        expect(match_result).to be_empty
      end

    end

  end
end
# rubocop:enable Naming/VariableNumber
