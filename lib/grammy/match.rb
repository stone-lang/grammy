require "grammy/location"


# A Match represents a successful match of a pattern in the input string.
# It contains the matched text and its start and end locations.
module Grammy
  # NOTE: start/end are a "closed interval", the locations of the first and last character of the match.
  class Match < Data.define(:text, :start_location, :end_location)

    def self.new(text, start_location = Grammy::Location.new, end_location = Grammy::Location.new)
      super
    end

    def empty? = text.nil?
    def to_s = text
    def inspect = "#<Match #{text} (#{start_location}..#{end_location})>"
    def pretty_print(pp) = pp.text inspect # For IRB output.

  end
end
