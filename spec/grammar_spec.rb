require "grammy/grammar"
require "grammy/match"


RSpec.describe Grammy::Grammar do

  subject(:grammar_instance) { grammar.new(scanner) }
  let(:grammar) do
    Class.new(described_class) do
      root :greet
      rule(:greet) { "hello" }
    end
  end
  let(:scanner) { instance_double(Grammy::Scanner, match: nil) }

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

  describe "#root_rule" do
    it "returns the root rule defined in the class" do
      expect(grammar_instance.root_rule.call).to eq("hello")
    end
  end

  describe "using primitive combinators in a rule" do

    let(:scanner) { Grammy::Scanner.new(input) }
    let(:input) { "abc123" }

    context "with a `match` combinator" do

      before do
        grammar.class_eval do
          rule(:match1) { match("abc") }
        end
      end

      let(:rule) { grammar_instance.rule(:match1) }

      it "returns a Match matching the string" do
        match_result = rule.call.match(scanner)
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

      let(:rule) { grammar_instance.rule(:seq1) }

      it "returns a Match for each match of the string" do
        match_result = rule.call.match(scanner)
        expect(match_result).to be_an(Array)
        expect(match_result.first.matched_string).to eq("abc")
        expect(match_result.last.matched_string).to eq("123")
      end
    end

  end
end
