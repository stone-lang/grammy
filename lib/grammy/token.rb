require "grammy/match"


# A Token is a Match, plus the name of the token rule it matched.
# It can also have a value, providing a more useful representation of the matched text.

module Grammy
  class Token < Data.define(:name, :match, :value)

    def self.new(name, match = nil, value = nil)
      match = Grammy::Match.new(match) unless match.is_a?(Grammy::Match)
      super
    end

    # TODO: Extract this into a Data helper. Better yet, create a Value class for value objects.
    # UHH: I think Data **already** has `with`!
    def with(value:) = self.class.new(name, match, value)

    def text = match.text
    def start_location = match.start_location
    def end_location = match.end_location

    def to_s = text
    def inspect = "#<Token #{name}: \"#{text}\"#{inspect_value}>"
    def inspect_value = value ? " (#{value})" : ""
    def pretty_print(pp) = pp.text inspect # For IRB output.

  end
end
