require "grammy/grammar"


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

end
