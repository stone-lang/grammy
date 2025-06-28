require "grammy/matcher"
require "grammy/match"


module Grammy
  class Matcher
    class SOL < Matcher

      def initialize = super(nil)

      def match(scanner)
        scanner.location.column == 1 ? Match.new(nil, scanner.location, scanner.location) : nil
      end

    end
  end
end
