require "spec_helper"
require "debug"
require "grammy/grammar"
require "grammy/parser"

class LiteralGrammar < Grammy::Grammar
  start(:plus)
  rule(:plus) {
    match("+")
  }
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
end
