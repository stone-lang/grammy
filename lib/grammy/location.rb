module Grammy
  # line/column are 1-based.
  # offset is 0-based character position in the full input string.
  class Location < Data.define(:line, :column, :offset)

    def self.new(line = 1, column = 1, offset = 0)
      super
    end

    def advance(text)
      newline_count = text.count("\n")
      new_offset = offset + text.length
      new_line = line + newline_count
      if newline_count.zero?
        new_column = column + text.length
      else
        new_column = text.length - text.rindex("\n")
      end
      Location.new(new_line, new_column, new_offset)
    end

    def to_s = "(#{line},#{column})"
    def inspect = to_s
    def pretty_print(pp) = pp.text inspect # For IRB output.

  end
end
