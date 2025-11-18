module Grammy
  class Tree
    module Transformation
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def transform_rules
          @transform_rules ||= {}
        end

        def transform(name, &block)
          transform_rules[name.to_sym] = block
        end
      end

      def transform(node)
        return apply_rule(node) if has_rule?(node)
        return node unless node.respond_to?(:children)
        return transform(node.children.first) if single_child?(node)

        transform_all_children(node)
      end

      private def has_rule?(node)
        self.class.transform_rules[node.name.to_sym]
      end

      private def apply_rule(node)
        rule = self.class.transform_rules[node.name.to_sym]
        instance_exec(node, &rule)
      end

      private def single_child?(node)
        node.children.size == 1
      end

      private def transform_all_children(node)
        children = node.children.map { |child| transform(child) }
        node.class.new(node.name, children)
      end
    end
  end
end
