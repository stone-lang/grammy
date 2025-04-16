module Grammy
  # row/column are 1-based.
  # index is 0-based, with respect to the full input string.
  class Position < Data.define(:row, :column, :index)
    def advance(text)
      newline_count = text.count("\n")
      new_index = index + text.length
      new_row = row + newline_count
      if newline_count.zero?
        new_column = column + text.length
      else
        new_column = text.length - text.rindex("\n")
      end
      Position.new(new_row, new_column, new_index)
    end

    def to_s = "(#{row},#{column})"
    def inspect = to_s
    def pretty_print(pp) = pp.text inspect # For IRB output.

  end
end
