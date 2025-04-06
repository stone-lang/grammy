module Grammy
  # start/end are a "closed interval": positions of first and last character of match.
  class Match < Data.define(:matched_string, :start_position, :end_position)
  end
end
