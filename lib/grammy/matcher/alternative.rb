require "grammy/matcher"


module Grammy
  class Matcher
    class Alternative < Matcher

      def initialize(*matchers) = @matchers = matchers

      def match(scanner)
        @matchers.each do |matcher|
          mark = scanner.mark
          result = matcher.match(scanner)
          return result if result
          scanner.backtrack(mark)
        end
        nil
      end

    end
  end
end
