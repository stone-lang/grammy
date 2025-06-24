module Grammy
  class Tree < Data.define(:name, :children)
    INDENTATION = 4

    # Make it easier to create nested trees.
    def self.new(name, children = [], &block)
      children = yield if block
      super(name:, children: Array(children))
    end

    def empty? = children.flatten.compact.empty?
    def leaves = children.flat_map { it.is_a?(self.class) ? it.leaves : it }.compact
    def tokens = leaves.flatten

    def to_s(level = 0) = ([to_s_base(level)] + children.map{ to_s_child(it, level) }).join("\n")

    def inspect(level = 0) = ([inspect_base(level)] + children.map{ to_s_child(it, level) }).join("\n")
    def to_h = {name:, children: children.map(&:to_h)}
    def pretty_print(pp) = pp.text inspect # For IRB output.

    private def to_s_base(level) = "#{indent(level)}#{name}"
    private def inspect_base(level) = "#{indent(level)}#<#{class_name} #{name.inspect}>"
    private def to_s_child(child, level) = child.is_a?(self.class) ? child.to_s(level + 1) : to_s_leaf(child, level + 1)
    private def to_s_leaf(leaf, level) = "#{indent(level)}#{leaf}"
    private def indent(level) = " " * (level * INDENTATION)
    private def class_name = self.class.name.split("::").last

  end
end
