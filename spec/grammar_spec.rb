require "grammy/grammar"
require "grammy/scanner"
require "grammy/token"


# rubocop:disable Naming/VariableNumber,RSpec/MultipleMemoizedHelpers
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
    let(:match_results) { results.map(&:text) }
    let(:results) { parse_tree.leaves.flatten }
    let(:parse_tree) { grammar_instance.execute_rule(rule) }

    context "with a `str` combinator" do

      before do
        grammar.class_eval do
          rule(:match1) { str("abc") }
        end
      end

      let(:rule) { :match1 }

      it "returns a Token matching the string" do
        expect(parse_tree.name).to eq("match1")
        expect(results.map(&:class)).to eq([Grammy::Match])
        expect(match_results).to eq(["abc"])
      end
    end

    context "with a `seq` combinator" do

      before do
        grammar.class_eval do
          rule(:seq1) { seq(str("abc"), str("123")) }
        end
      end

      let(:rule) { :seq1 }

      it "returns a Token for each match of the string" do
        expect(parse_tree.name).to eq("seq1")
        expect(match_results).to eq(["abc", "123"])
      end
    end

    context "with an `alt` combinator" do

      before do
        grammar.class_eval do
          rule(:alt1) { alt(reg(/\d+/), str("abc")) }
        end
      end

      let(:rule) { :alt1 }

      it "returns a Token with the matched pattern" do
        expect(parse_tree.name).to eq("alt1")
        expect(match_results).to eq(["abc"])
      end
    end

    context "with a `rep` combinator" do

      before do
        grammar.class_eval do
          rule(:rep0_1) { rep(reg(/\d+x/), 0..1) }
          rule(:rep1_) { rep(reg(/\d+x/), 1..) }
          rule(:rep0_) { rep(str("abc"), 0..) }
        end
      end

      let(:input) { "123x1234x54321xY" }

      it "allows 0 or 1 matches" do
        parse_tree = grammar_instance.execute_rule(:rep0_1)
        match_results = parse_tree.leaves.map(&:text)
        expect(parse_tree.name).to eq("rep0_1")
        expect(match_results).to eq(["123x"])
      end

      it "allows 1 or more matches" do
        parse_tree = grammar_instance.execute_rule(:rep1_)
        match_results = parse_tree.leaves.map(&:text)
        expect(match_results).to eq(["123x", "1234x", "54321x"])
      end

      it "allows no matches" do
        parse_tree = grammar_instance.execute_rule(:rep0_)
        match_results = parse_tree.leaves.map(&:text)
        expect(match_results).to be_empty
      end

    end

  end

end
# rubocop:enable Naming/VariableNumber,RSpec/MultipleMemoizedHelpers
