require "grammy/token"


module Grammy
  class Matcher

    def initialize(pattern) = @pattern = pattern

    # Returns a Token, if the pattern matches, else `nil`.
    def match(scanner) = scanner.match(@pattern)

    # DSL for sequence, alternative, and repetition.
    def +(other) = Matcher::Sequence.new(self, other)
    def |(other) = Matcher::Alternative.new(self, other)
    def [](range) = Matcher::Repetition.new(self, range)

  end
end
