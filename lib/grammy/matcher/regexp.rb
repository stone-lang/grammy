require "grammy/matcher"


module Grammy
  class Matcher
    class Regexp < Matcher

      def initialize(pattern) = @pattern = pattern

      def match(scanner)
        scanner.match_regexp(@pattern)
      end

    end
  end
end
