require "grammy/matcher"
require "grammy/matcher/sequence"
require "grammy/matcher/alternative"


module Grammy
  module Combinator
    module Primitives

      protected def match(pattern) = Grammy::Matcher.new(pattern)
      protected def seq(*matchers) = Grammy::Matcher::Sequence.new(*matchers)
      protected def alt(*matchers) = Grammy::Matcher::Alternative.new(*matchers)

      # Use these aliases if you have naming conflicts with your grammar.
      alias _match match
      alias _seq seq
      alias _alt alt

    end
  end
end
