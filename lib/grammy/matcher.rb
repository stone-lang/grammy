require "grammy/match"


module Grammy
  class Matcher

    def initialize(pattern) = @pattern = pattern

    def match(scanner) = fail NotImplementedError, "abstract method -- must override in derived classes"

    # DSL for sequence, alternative, and repetition.
    def +(other) = Matcher::Sequence.new(self, other)
    def |(other) = Matcher::Alternative.new(self, other)
    def [](range) = Matcher::Repetition.new(self, range)

  end
end
