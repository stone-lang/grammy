module Grammy
  class ParseTree < Data.define(:name, :children)
    INDENTATION = 4

    # Make it easier to create nested trees.
    def self.new(name, children = [], &block)
      children = Array(yield) if block
      super(name:, children:)
    end

    def to_s(level = 0) = ([to_s_base(level)] + to_s_children(level)).join("\n")
    def inspect = to_s
    def to_h = {name:, children: children.map(&:to_h)}
    def pretty_print(pp) = pp.text inspect # For IRB output.

    private def to_s_base(level) = "#{indent(level)}#<ParseTree name=#{name.inspect}>"
    private def to_s_children(level) = children.map { |child| child.to_s(level + 1) }
    private def indent(level) = " " * (level * INDENTATION)

  end
end
