module Grammy
  # row/column are 1-based.
  # index is 0-based, with respect to the full input string.
  class Position < Data.define(:row, :column, :index)
  end
end
