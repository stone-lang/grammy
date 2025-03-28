require "grammy"

# A scanner allows us to do 3 things with an input (String or File::Source):
# 1. Match a pattern (String or Regexp) at the current position
# 2. Advance the current position by a given offset
# 3. Backtrack to a previous position

module Grammy

  class Scanner

    attr_reader :input, :pos

    def initialize(input)
      @input = input
      @pos = 0
    end

    # TODO: Rename as `consume` to match common PEG terminology.
    def advance(offset)
      @pos += offset
    end

    def backtrack(pos)
      @pos = pos
      nil
    end

    def match(pattern)
      case pattern
      when Regexp
        match_regexp(pattern)
      when String
        match_string(pattern)
      else
        fail ArgumentError, "Invalid pattern: #{pattern} of class #{pattern.class}"
      end
    end

    private def match_regexp(pattern)
      match = @input[@pos..].match(/\A#{pattern}/)
      return nil unless match
      advance(match[0].size)
      match[0]
    end

    private def match_string(pattern)
      return nil unless @input[@pos..].start_with?(pattern)
      advance(pattern.size)
      pattern
    end

  end

end
