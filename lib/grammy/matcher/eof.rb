require "grammy/matcher"
require "grammy/match"


module Grammy
  class Matcher
    class EOF < Matcher

      def initialize = super(nil)

      def match(scanner)
        scanner.finished? ? Match.new(nil, scanner.location, scanner.location) : nil
      end

    end
  end
end
