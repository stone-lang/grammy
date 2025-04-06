require "grammy/position"
require "grammy/match"

module Grammy

  class Scanner
    def initialize(input)
      @input = input.is_a?(String) ? input : input.read
      @position = Position.new(1, 1, 0)
      @marks = [] # stack of Positions
    end

    # Try to match given String or Regexp at current position.
    # Returns `nil` if pattern does not match.
    # Otherwise, updates @position and returns a Match object.
    def match(pattern)
      return nil if @position.index >= @input.size

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
      @marks.push(@position)
      @position
    end

    def backtrack(mark)
      fail ArgumentError, "can only backtrack the top mark" unless @marks.last == mark
      @position = mark
      @marks.pop
    end

    # Permanently consume input, confirming we'll never backtrack to mark again.
    def consume(mark)
      fail ArgumentError, "can only consume the top mark" unless @marks.last == mark
      @marks.pop
    end

    private def remaining_input
      @input[@position.index..]
    end

    # Returns matched text and its location (or nil).
    # Moves the current position forward to the character *after* the match.
    private def match_text(text)
      return nil unless text && !text.empty?
      start_pos = @position
      end_pos = advance_position(start_pos, text[0...-1])
      @position = advance_position(end_pos, text[-1])
      Match.new(text, start_pos, end_pos)
    end

    private def advance_position(position, text)
      newline_count = text.count("\n")
      new_index = position.index + text.length
      new_row = position.row + newline_count
      if newline_count.zero?
        new_column = position.column + text.length
      else
        new_column = text.length - text.rindex("\n")
      end
      Position.new(new_row, new_column, new_index)
    end
  end

end
