require "grammy/location"
require "grammy/match"


# PEG parsers don't need a lexer, so this is basically half a lexer.
# It needs to implement backtracking for the PEG parser.
module Grammy

  class Scanner

    attr_reader :location, :input

    def initialize(input)
      @input = input.is_a?(String) ? input : input.read
      @location = Location.new(1, 1, 0)
      @marks = [] # stack of Locations
    end

    # Try to match given String or Regexp at current location.
    # Returns `nil` if pattern does not match.
    # Otherwise, updates @location and returns a Match object.
    def match(pattern)
      return nil if @location.index >= @input.size

      if pattern.is_a?(String)
        match_string(pattern)
      elsif pattern.is_a?(Regexp)
        match_regex(pattern)
      else
        fail ArgumentError, "Unsupported pattern type: #{pattern.class}"
      end
    end

    def match_string(pattern)
      return nil unless remaining_input.start_with?(pattern)
      match_text(pattern)
    end

    def match_regex(pattern)
      anchored_regex = Regexp.new("\\A(?:#{pattern.source})", pattern.options)
      match = remaining_input.match(anchored_regex)
      return nil unless match
      match_text(match[0])
    end

    def mark
      @marks.push(@location)
      @location
    end

    def backtrack(mark)
      fail ArgumentError, "can only backtrack the top mark" unless @marks.last == mark
      @location = mark
      @marks.pop
    end

    # Permanently consume input, confirming we'll never backtrack to mark again.
    def consume(mark)
      fail ArgumentError, "can only consume the top mark" unless @marks.last == mark
      @marks.pop
    end

    def finished?
      @location.index == @input.size
    end

    private def remaining_input
      @input[@location.index..]
    end

    # Returns matched text and its location (or nil).
    # Moves the current location forward to the character *after* the match.
    private def match_text(text)
      return nil unless text && !text.empty?
      start_pos = @location
      end_pos = start_pos.advance(text[0...-1])
      @location = end_pos.advance(text[-1])
      Match.new(text, start_pos, end_pos)
    end

  end
end
