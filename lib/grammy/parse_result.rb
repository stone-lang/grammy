module Grammy
  class ParseResult < Data.define(:parse_tree)

    def self.new(parse_tree) = super(parse_tree:)

    def tokens = parse_tree.leaves.map(&:matched_string).flatten

  end
end
