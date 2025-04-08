require "grammy/matcher"


module Grammy
  module Combinator
    module Primitives

      protected def match(pattern) = Grammy::Matcher.new(pattern)

      # Use these aliases if you have naming conflicts with your grammar.
      alias _match match

    end
  end
end
