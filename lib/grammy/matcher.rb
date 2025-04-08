require "grammy/match"


module Grammy
  class Matcher

    def initialize(pattern) = @pattern = pattern

    # Returns a Match, if the pattern matches, else `nil`.
    def match(scanner) = scanner.match(@pattern)

  end
end
