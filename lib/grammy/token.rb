require "grammy/position"


module Grammy
  # start/end are a "closed interval": positions of first and last character of match.
  class Token < Data.define(:text, :start_position, :end_position)

    def self.new(text, start_position = Grammy::Position.new, end_position = Grammy::Position.new)
      super
    end

    def to_s = text.to_s
    def inspect = "#<Token #{text.inspect} #{start_position}..#{end_position}>"
    def pretty_print(pp) = pp.text inspect # For IRB output.

  end
end
