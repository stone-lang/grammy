require "grammy/matcher"
require "grammy/match"


module Grammy
  class Matcher
    class SOF < Matcher

      def initialize = super(nil)

      def match(scanner)
        scanner.location.index.zero? ? Match.new(nil, scanner.location, scanner.location) : nil
      end

    end
  end
end
