module Grammy
  # start/end are a "closed interval": positions of first and last character of match.
  class Match < Data.define(:matched_string, :start_position, :end_position)

    def to_s = "#<Match #{matched_string.inspect} #{start_position}..#{end_position}>"
    def inspect = to_s
    def pretty_print(pp) = pp.text inspect # For IRB output.

  end
end
