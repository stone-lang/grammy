require "grammy/matcher"


module Grammy
  class Matcher
    class Alternative < Matcher

      def initialize(*alternatives) = @alternatives = alternatives

      def match(scanner)
        @alternatives.each do |matcher|
          mark = scanner.mark
          result = matcher.match(scanner)
          return result if result && !result.empty?
          scanner.backtrack(mark)
        end
        nil
      end

    end
  end
end
