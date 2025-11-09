require "grammy/tree"


# The purpose of the Transformer is to provide a simpler DSL within `transform` blocks.
# If the `transform` is for a ParseTree, you can use `name`, `children`, and `build(child)`.
# If the `transform` is for a Token, you can use `name`, `token`, and `text`.
module Grammy
  class AST < Tree
    class Transformer

      def initialize(node, node_class)
        @node = node
        @node_class = node_class
      end

      def build(child) = @node_class.build(child)

      def name = @node.name.to_sym
      def children = @node.children
      def token = @node
      def text = token.text

    end
  end
end
