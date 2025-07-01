require "grammy/tree/transformation"
require "grammy/parse_tree"
require "grammy/token"


RSpec.describe Grammy::Tree::Transformation, :integration do

  subject(:transformer) { transformer_class.new }
  let(:transformer_class) do
    Class.new do
      include Grammy::Tree::Transformation

      transform(:plus) { |node| left, _, right = node.children; Grammy::Tree.new(:add, [transform(left), transform(right)]) }
      transform(:number) { |token| token.with(value: token.text.to_i) }
    end
  end

  context "with a simple tree" do
    let(:parse_tree) {
      Grammy::ParseTree.new(:plus, [
        Grammy::Token.new(:number, "1"),
        Grammy::Token.new(:operator, "+"),
        Grammy::Token.new(:number, "2"),
      ])
    }

    # TODO: It might be easier to just print out the resulting tree and compare against that.
    it "transforms it into a tree with correct structure and values" do
      ast = transformer.transform(parse_tree)
      expect(ast.name).to eq(:add)
      expect(ast.children.size).to eq(2)
      expect(ast.children.first.value).to eq(1)
      expect(ast.children.last.value).to eq(2)
    end
  end

  context "with a nested tree" do
    let(:parse_tree) {
      Grammy::ParseTree.new(:plus, [
        Grammy::ParseTree.new(:plus, [
          Grammy::Token.new(:number, "1"),
          Grammy::Token.new(:operator, "+"),
          Grammy::Token.new(:number, "2"),
        ]),
        Grammy::Token.new(:operator, "+"),
        Grammy::Token.new(:number, "3"),
      ])
    }

    # TODO: It might be easier to just print out the resulting tree and compare against that.
    it "transforms it into a tree with correct structure and values" do
      ast = transformer.transform(parse_tree)
      expect(ast.name).to eq(:add)
      expect(ast.children.size).to eq(2)
      expect(ast.children.first).to be_a(Grammy::Tree)
      expect(ast.children.first.children.first.value).to eq(1)
      expect(ast.children.first.children.last.value).to eq(2)
      expect(ast.children.last.value).to eq(3)
    end
  end

end
