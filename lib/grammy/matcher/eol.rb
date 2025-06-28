require "grammy/matcher"
require "grammy/match"


module Grammy
  class Matcher
    class EOL < Matcher

      def initialize = super(nil)

      def match(scanner)
        scanner.match_regexp(/\r?\n/)
      end

    end
  end
end
