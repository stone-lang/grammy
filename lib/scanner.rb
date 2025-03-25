Position = Data.define(:row, :column, :index)
Match = Data.define(:matched_string, :start_position, :end_position)

class Scanner
  def initialize(input)
    @input = input
    @position = Position.new(1, 1, 0)
    @marks = []
  end

  def current_index
    @position.index
  end

  def mark
    @marks.push(@position)
  end

  # Backtrack to most recently marked position.
  def rollback
    @position = @marks.pop unless @marks.empty?
  end

  # Permanently consume input, confirming we'll never backtrack to current mark.
  def commit
    @marks.pop unless @marks.empty?
  end

  # Try to match given pattern (String or Regexp) at current position.
  # On success, consumes input and returns a Match object.
  # Returns `nil` if pattern does not match.
  def match(pattern)
    return nil if @position.index >= @input.size

    start_pos = @position
    matched_text = extract_match(pattern)
    return nil unless matched_text

    @position = advance_position(@position, matched_text)
    Match.new(matched_text, start_pos, @position)
  end

  private def remaining_input
    @input[@position.index..]
  end

  private def extract_match(pattern)
    if pattern.is_a?(String)
      return pattern if remaining_input.start_with?(pattern)
    elsif pattern.is_a?(Regexp)
      anchored_regex = Regexp.new("\\A(?:#{pattern.source})", pattern.options)
      m = remaining_input.match(anchored_regex)
      return m[0] if m
    else
      fail ArgumentError, "Unsupported pattern type: #{pattern.class}"
    end
    nil
  end

  private def advance_position(position, text)
    newline_count = text.count("\n")
    last_newline_index = text.rindex("\n") || -position.column
    new_index = position.index + text.length
    new_row = position.row + newline_count
    new_column = text.length - last_newline_index
    Position.new(new_row, new_column, new_index)
  end
end
