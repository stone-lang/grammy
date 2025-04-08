require "grammy/matcher"


module Grammy
  class Matcher
    class Sequence < Matcher

      def initialize(*submatchers) = @submatchers = submatchers

      def match(scanner)
        @submatchers.reduce([]) do |results, matcher|
          m = matcher.match(scanner)
          return nil unless m
          results << m
        end
      end

    end
  end
end
