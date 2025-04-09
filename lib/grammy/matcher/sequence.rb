require "grammy/matcher"


module Grammy
  class Matcher
    class Sequence < Matcher

      def initialize(*submatchers) = @submatchers = submatchers

      def match(scanner)
        @submatchers.map { |matcher| matcher.match(scanner) || (return nil) }
      end

    end
  end
end
