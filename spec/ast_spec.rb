require "grammy/ast"
require "grammy/parse_tree"
require "grammy/token"


# Test AST implementation for testing Grammy::AST transformation functionality
class TestAST < Grammy::AST
  transform :plus do
    left, _, right = children
    Add.new(build(left), build(right))
  end

  transform :number do
    token.with(value: text.to_i)
  end

  def value
    case name
    when :add
      children.sum(&:value)
    else
      fail "Unknown node type: #{name}"
    end
  end

  class Add < self
    def self.new(left, right)
      super(:add, [left, right])
    end
  end
end


RSpec.describe Grammy::AST, :integration do
  let(:simple_tree) do
    Grammy::ParseTree.new(:plus, [
      Grammy::Token.new(:number, "1"),
      Grammy::Token.new(:operator, "+"),
      Grammy::Token.new(:number, "2"),
    ])
  end

  let(:nested_tree) do
    Grammy::ParseTree.new(:plus, [
      Grammy::ParseTree.new(:plus, [
        Grammy::Token.new(:number, "1"),
        Grammy::Token.new(:operator, "+"),
        Grammy::Token.new(:number, "2"),
      ]),
      Grammy::Token.new(:operator, "+"),
      Grammy::Token.new(:number, "3"),
    ])
  end

  describe ".build" do
    it "transforms a parse tree into an AST with correct structure" do
      ast = TestAST.build(simple_tree)
      expect(ast.name).to eq(:add)
      expect(ast).to be_a(TestAST::Add)
    end

    it "transforms child nodes recursively" do
      ast = TestAST.build(simple_tree)
      expect(ast.children.size).to eq(2)
      expect(ast.children.first).to be_a(Grammy::Token)
      expect(ast.children.last).to be_a(Grammy::Token)
    end

    it "applies transforms to tokens" do
      ast = TestAST.build(simple_tree)
      expect(ast.children.first.value).to eq(1)
      expect(ast.children.last.value).to eq(2)
    end

    it "handles nested parse trees" do
      ast = TestAST.build(nested_tree)
      expect(ast.name).to eq(:add)
      expect(ast.children.first).to be_a(TestAST::Add)
      expect(ast.children.last.value).to eq(3)
    end
  end

  describe "custom node methods" do
    it "allows custom behavior on transformed nodes" do
      ast = TestAST.build(simple_tree)
      expect(ast.value).to eq(3)
    end

    it "works with nested structures" do
      ast = TestAST.build(nested_tree)
      expect(ast.value).to eq(6)
    end
  end
end
