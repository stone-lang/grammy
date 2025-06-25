require "grammy/matcher/string"
require "grammy/matcher/regexp"
require "grammy/matcher/sequence"
require "grammy/matcher/alternative"
require "grammy/matcher/repetition"


module Grammy
  module Combinator
    module Primitives

      protected def str(pattern) = Grammy::Matcher::String.new(pattern)
      protected def reg(pattern) = Grammy::Matcher::Regexp.new(pattern)
      protected def seq(*matchers) = Grammy::Matcher::Sequence.new(*matchers)
      protected def alt(*matchers) = Grammy::Matcher::Alternative.new(*matchers)
      protected def rep(matcher, count_range) = Grammy::Matcher::Repetition.new(matcher, count_range)

      # Use these aliases if you have naming conflicts with your grammar.
      alias _seq seq
      alias _alt alt
      alias _rep rep
      alias _str str
      alias _reg reg

    end
  end
end
