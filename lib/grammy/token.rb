require "grammy/location"


module Grammy
  # start/end are a "closed interval": locations of first and last character of match.
  class Token < Data.define(:text, :start_location, :end_location)

    def self.new(text, start_location = Grammy::Location.new, end_location = Grammy::Location.new)
      super
    end

    def to_s = text.to_s
    def inspect = "#<Token #{text.inspect} #{start_location}..#{end_location}>"
    def pretty_print(pp) = pp.text inspect # For IRB output.

  end
end
