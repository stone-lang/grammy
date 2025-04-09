require "grammy/matcher"

module Grammy
  class Matcher
    class Repetition < Matcher

      def initialize(submatcher, count_range)
        @submatcher = submatcher
        @count_range = count_range
      end

      def match(scanner)
        all_matches = (1..max_matches).lazy.map { @submatcher.match(scanner) }
        successful_matches = all_matches.take_while { |match| !match.nil? }.to_a
        successful_matches.tap do |results|
          return nil if results.size < @count_range.begin
        end
      end

      private def max_matches = @count_range.size - 1

    end
  end
end
