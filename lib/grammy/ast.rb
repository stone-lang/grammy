require "grammy/tree"
require "grammy/ast/transformer"


module Grammy
  class AST < Tree

    class << self
      def transform(name, &blk) = transforms[name.to_sym] = blk

      # The `node` will be a ParseTree or a Token. The code can handle other trees and leaves though.
      # TODO: FIXME: Change this to use `node.each`, checking each node to see if there is a transform.
      # ... if there isn't, we should treat the node's children as belonging to the node's parent.
      def build(node)
        node_name = node.respond_to?(:name) ? node.name.to_sym : nil
        blk = transforms[node_name]
        if blk
          Grammy::AST::Transformer.new(node, self).instance_exec(&blk)
        elsif node.respond_to?(:children)
          # TODO: FIXME: We should pass the children, not ourself.
          node.with(children: node.children.map{ build(it) })
          # node
        else
          node
        end
      end

      def transforms = @transforms ||= {}
    end

  end
end
