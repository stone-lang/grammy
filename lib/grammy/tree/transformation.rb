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
        rule = self.class.transform_rules[node.name.to_sym]
        if rule
          instance_exec(node, &rule)
        elsif node.respond_to?(:children)
          children = node.children.map { |child| transform(child) }
          node.class.new(node.name, children)
        else
          node
        end
      end
    end
  end
end
