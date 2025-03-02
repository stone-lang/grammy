require "grammy"

module Grammy
  module Combinators
    class Matcher
      attr_reader :pattern

      def initialize(pattern)
        @pattern = pattern
      end

      def match(scanner)
        scanner.match(@pattern)
      end

      def +(other)
        SequenceMatcher.new(self, other)
      end

      def |(other)
        ChoiceMatcher.new(self, other)
      end

    end

    class SequenceMatcher < Matcher
      def initialize(*matchers)
        @matchers = matchers.map { |matcher| matcher.is_a?(Matcher) ? matcher : Matcher.new(matcher) }
      end

      def match(scanner)
        start_pos = scanner.pos
        results = []
        @matchers.each do |matcher|
          result = matcher.match(scanner)
          return scanner.backtrack(start_pos) unless result
          results << result
        end
        results
      end
    end

    class ChoiceMatcher < Matcher
      def initialize(*matchers)
        @matchers = matchers.map { |matcher| matcher.is_a?(Matcher) ? matcher : Matcher.new(matcher) }
      end

      def match(scanner)
        start_pos = scanner.pos
        @matchers.each do |matcher|
          result = matcher.match(scanner)
          return result if result
          scanner.backtrack(start_pos)
        end
        nil
      end
    end

    protected def match(pattern)
      Matcher.new(pattern)
    end

    protected def sequence(*matchers)
      SequenceMatcher.new(*matchers)
    end

    protected def choice(*matchers)
      ChoiceMatcher.new(*matchers)
    end

  end
end
