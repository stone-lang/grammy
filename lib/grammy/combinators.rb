require "grammy"

module Grammy
  module Combinators
    protected def match(pattern)
      scanner.match(pattern)
    end

    protected def sequence(*children)
      start_pos = scanner.pos
      results = []
      children.each do |child|
        return scanner.backtrack(start_pos) unless child
        results << child
      end
    end

    protected def choice(*children)
      start_pos = scanner.pos
      children.each do |child|
        return child if child
        scanner.backtrack(start_pos)
      end
      nil
    end

    # def repeat(child, range)
    #   results = []
    #   while child
    #     results << child
    #     break if range.end && results.size >= range.end
    #   end
    #   return nil if results.size < range.begin
    #   results
    # end
  end
end
