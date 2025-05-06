require "grammy/matcher"

module Grammy
  class Matcher
    class Repetition < Matcher

      def initialize(submatcher, count_range)
        @submatcher = submatcher
        @count_range = count_range
      end

      def match(scanner)
        all_matches = (1..@count_range.end).lazy.map { @submatcher.match(scanner) }
        successful_matches = all_matches.take_while { |match| !match.nil? }.to_a
        successful_matches.tap do |results|
          return nil unless @count_range.include?(results.size)
        end
      end

    end
  end
end
