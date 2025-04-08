require "grammy/matcher"
require "grammy/matcher/sequence"


module Grammy
  module Combinator
    module Primitives

      protected def match(pattern) = Grammy::Matcher.new(pattern)
      protected def seq(*matchers) = Grammy::Matcher::Sequence.new(*matchers)

      # Use these aliases if you have naming conflicts with your grammar.
      alias _match match
      alias _seq seq

    end
  end
end
