require "grammy/matcher"


module Grammy
  class Matcher
    class String < Matcher

      def initialize(string) = @string = string

      def match(scanner)
        scanner.match_string(@string)
      end

    end
  end
end
