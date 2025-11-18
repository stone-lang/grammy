require "grammy/grammar"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "Alternative matcher with terminals", :integration do
  subject(:parse_tree) { grammar.parse(input) }

  context "when a rule contains terminals and nested alternatives" do
    let(:grammar) { ArgumentListGrammar }

    context "with a simple parenthesized number" do
      let(:input) { "(5)" }

      it "produces a non-empty parse tree for the rule" do
        expect(parse_tree).not_to be_nil
        expect(parse_tree.name).to eq(:argument_list)
        # The parse tree should have children representing the matched content
        expect(parse_tree.children.length).to be > 0
      end

      it "correctly captures all tokens" do
        tokens = parse_tree.tokens.map(&:to_s)
        expect(tokens).to eq(["(", "5", ")"])
      end
    end

    context "with multiple arguments" do
      let(:input) { "(5, 3)" }

      it "produces a non-empty parse tree for the rule" do
        expect(parse_tree).not_to be_nil
        expect(parse_tree.name).to eq(:argument_list)
        expect(parse_tree.children.length).to be > 0
      end

      it "correctly captures all tokens" do
        tokens = parse_tree.tokens.map(&:to_s)
        expect(tokens).to eq(["(", "5", ", ", "3", ")"])
      end
    end

    context "with empty argument list" do
      let(:input) { "()" }

      it "produces a parse tree for the rule" do
        expect(parse_tree).not_to be_nil
        expect(parse_tree.name).to eq(:argument_list)
      end

      it "correctly captures the parentheses tokens" do
        tokens = parse_tree.tokens.map(&:to_s)
        expect(tokens).to eq(["(", ")"])
      end
    end
  end
end


class ArgumentListGrammar < Grammy::Grammar
  start :argument_list

  rule(:argument_list) { lparen + (expression + (comma + expression)[0..])[0..1] + rparen }
  rule(:expression) { number }

  terminal(:lparen, "(")
  terminal(:rparen, ")")
  terminal(:comma, ", ")
  terminal(:number, /\d+/)
end
# rubocop:enable RSpec/DescribeClass
