module Grammy
  module Refinements
    refine String do
      def +(other)
        case other
        when String, Regexp
          Grammy::Combinators::Matcher.new(self) + Grammy::Combinators::Matcher.new(other)
        else
          Grammy::Combinators::Matcher.new(self) + other
        end
      end

      def |(other)
        case other
        when String, Regexp
          Grammy::Combinators::Matcher.new(self) | Grammy::Combinators::Matcher.new(other)
        else
          Grammy::Combinators::Matcher.new(self) | other
        end
      end

    end

    refine Regexp do
      def +(other)
        case other
        when String, Regexp
          Grammy::Combinators::Matcher.new(self) + Grammy::Combinators::Matcher.new(other)
        else
          Grammy::Combinators::Matcher.new(self) + other
        end
      end

      def |(other)
        case other
        when String, Regexp
          Grammy::Combinators::Matcher.new(self) | Grammy::Combinators::Matcher.new(other)
        else
          Grammy::Combinators::Matcher.new(self) | other
        end
      end
    end
  end
end
