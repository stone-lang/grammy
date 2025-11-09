# Custom RSpec matchers for Grammy domain concepts

# Matcher for testing grammar parsing
#
# Usage:
#   expect(grammar).to parse("helloworld").as(["hello", "world"])
RSpec::Matchers.define :parse do |input|
  match do |grammar|
    fail "Must provide expected tokens with #as" unless @expected_tokens

    begin
      parse_tree = grammar.parse(input)
      @actual = parse_tree.tokens.map(&:to_s)
      @actual == @expected_tokens
    rescue Grammy::ParseError => e
      @parse_error = e
      false
    end
  end

  chain :as do |expected_tokens|
    @expected_tokens = expected_tokens
  end

  failure_message do
    if @parse_error
      "expected grammar to parse '#{input}' as #{@expected_tokens}, but parsing failed with: #{@parse_error.message}"
    else
      "expected grammar to parse '#{input}' as #{@expected_tokens}, but got #{@actual}"
    end
  end

  failure_message_when_negated do
    "expected grammar not to parse '#{input}' as #{@expected_tokens}, but it did"
  end

  description do
    "parse input '#{input}' as #{@expected_tokens}"
  end
end

# Matcher for testing parse failures
#
# Usage:
#   expect(grammar).to fail_to_parse("invalid input")
RSpec::Matchers.define :fail_to_parse do |input|
  match do |grammar|

    grammar.parse(input)
    false
  rescue Grammy::ParseError
    true

  end

  failure_message do
    "expected grammar to fail parsing '#{input}', but it succeeded"
  end

  failure_message_when_negated do
    "expected grammar to successfully parse '#{input}', but it failed"
  end

  description do
    "fail to parse '#{input}'"
  end
end

# Matcher for testing scanner matches at specific locations
#
# Usage:
#   expect(match).to be_at_location(1, 5, 4)              # Checks start location
#   expect(match).to be_at_location(1, 5, 4).at_start     # Explicitly check start
#   expect(match).to be_at_location(1, 6, 5).at_end       # Check end location
RSpec::Matchers.define :be_at_location do |line, column, offset|
  match do |match|
    @actual_start = match.start_location
    @actual_end = match.end_location
    @expected_location = Grammy::Location.new(line, column, offset)

    if @which == :end
      @actual_end == @expected_location
    else
      # Default: check start location (covers both :start and nil)
      @actual_start == @expected_location
    end
  end

  chain :at_start do
    @which = :start
  end

  chain :at_end do
    @which = :end
  end

  failure_message do
    location = @which == :end ? @actual_end : @actual_start
    "expected match to be at location #{@expected_location}, but was at #{location}"
  end

  description do
    position = @which == :end ? "end" : "start"
    "be at #{position} location (line: #{line}, column: #{column}, offset: #{offset})"
  end
end

# Matcher for testing token text content
#
# Usage:
#   expect(parse_tree).to have_tokens(["hello", "world"])
RSpec::Matchers.define :have_tokens do |expected_tokens|
  match do |parse_tree|
    @actual_tokens = parse_tree.tokens.map(&:to_s)
    @actual_tokens == expected_tokens
  end

  failure_message do
    "expected parse tree to have tokens #{expected_tokens}, but got #{@actual_tokens}"
  end

  failure_message_when_negated do
    "expected parse tree not to have tokens #{expected_tokens}, but it did"
  end

  description do
    "have tokens #{expected_tokens}"
  end
end
