require "grammy/matcher"


module Grammy
  class Matcher
    class Sequence < Matcher

      def initialize(*submatchers) = @submatchers = submatchers

      def match(scanner)
        mark = scanner.mark
        results = collect_results(scanner, mark)
        return nil unless results

        scanner.consume(mark)
        results
      end

      private def collect_results(scanner, mark)
        results = []
        @submatchers.each do |matcher|
          result = matcher.match(scanner)
          return scanner.backtrack(mark) && nil unless result

          results << result
        end
        results
      end

    end
  end
end
