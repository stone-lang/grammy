# Grammy Test Suite

This document describes the testing strategy, conventions, and best practices for the Grammy parser combinator library.

## Philosophy

Grammy follows **strict Test-Driven Development (TDD)** practices:

1. **Red**: Write a failing test first
2. **Green**: Write the minimum code to make it pass
3. **Refactor**: Improve the code while keeping tests green

All code should be test-driven. No production code should be written without a failing test first.

## Test Organization

### Directory Structure

```text
spec/
├── README.md                    # This file
├── spec_helper.rb              # RSpec configuration
├── shared_examples/            # Reusable test behaviors
│   └── matcher_behavior.rb     # Common matcher tests
├── support/                    # Test helpers
│   └── matchers.rb             # Custom RSpec matchers
├── grammar/                    # Grammar DSL tests
├── primitives/                 # Primitive combinator tests
├── tree/                       # Tree transformation tests
└── *_spec.rb                   # Unit tests for main classes
```

### Test Types

#### Unit Tests

Tests for individual classes and methods in isolation. Use mocks/stubs when needed.

**Example**: `scanner_spec.rb`, `token_spec.rb`

#### Integration Tests

Tests that verify multiple components working together. Tagged with `:integration`.

**Example**: `grammar/dsl_spec.rb`, `ast_spec.rb`

**Run only integration tests**:

```bash
bundle exec rspec --tag integration
```


## Naming Conventions

### Test Descriptions

Use **present tense** to describe expected behavior:

```ruby
# ✅ Good
it "parses nested rules and returns leaf tokens" do

# ❌ Bad
it "parsed nested rules" do
```

### Be Specific

Test descriptions should clearly state what is being tested:

```ruby
# ✅ Good
it "returns nil when pattern does not match" do
it "advances scanner position after successful match" do

# ❌ Bad
it "works" do
it "handles input" do
```

### Context Blocks

Use `context` blocks to group related scenarios:

```ruby
describe "#match" do
  context "with matching input" do
    # ...
  end

  context "with non-matching input" do
    # ...
  end

  context "with empty input" do
    # ...
  end
end
```

## Test Structure

### Use Named Subjects

Always use `subject` with a descriptive name:

```ruby
# ✅ Good
subject(:scanner) { described_class.new(input) }

# ❌ Bad
subject { described_class.new(input) }
```

### One Logical Assertion Per Test

When practical, test one behavior per example:

```ruby
# ✅ Good - focused test
it "returns nil when no match" do
  expect(matcher.match(scanner)).to be_nil
end

it "does not advance scanner on failed match" do
  mark = scanner.mark
  matcher.match(scanner)
  expect(scanner.mark).to eq(mark)
end

# ⚠️ Acceptable for integration tests
it "tracks locations correctly across linefeeds" do
  # Multiple related assertions for complex behavior
end
```

### Use let and let! Appropriately

- Use `let` for lazy evaluation (most common)
- Use `let!` when setup must happen before the test runs
- Use `subject` for the primary object under test

```ruby
subject(:grammar) { MyGrammar }
let(:input) { "hello world" }
let(:scanner) { Grammy::Scanner.new(input) }
```

## Shared Examples

Reusable test behaviors are defined in `spec/shared_examples/`.

### Using Shared Examples

```ruby
RSpec.describe Grammy::Matcher::String do
  subject(:matcher) { described_class.new("abc") }

  it_behaves_like "a matcher" do
    let(:matching_input) { "abcdef" }
    let(:non_matching_input) { "xyz" }
  end
end
```

### Available Shared Examples

- **`"a matcher"`**: Tests basic matcher behavior (returns nil on failure, advances scanner on success)

## Custom Matchers

Domain-specific matchers are defined in `spec/support/matchers.rb`.

### parse

Test grammar parsing with readable syntax:

```ruby
expect(grammar).to parse("helloworld").as(["hello", "world"])
```

### fail_to_parse

Test that invalid input fails:

```ruby
expect(grammar).to fail_to_parse("invalid input")
```

### have_tokens

Test parse tree token content:

```ruby
expect(parse_tree).to have_tokens(["hello", "world"])
```

### be_at_location

Test scanner location tracking:

```ruby
expect(match).to be_at_location(1, 5, 4).at_start
expect(match).to be_at_location(2, 1, 10).at_end
```

## Testing Best Practices

### Test Edge Cases

Always test boundary conditions:

- Empty input
- Null values
- Unicode characters
- Very long strings
- Invalid input

```ruby
describe "edge cases" do
  context "with empty input" do
    let(:input) { "" }
    it "returns nil" do
      expect(scanner.match_string("x")).to be_nil
    end
  end
end
```

### Test Error Conditions

Verify that errors are raised appropriately:

```ruby
it "raises ArgumentError for invalid mark" do
  fake_mark = Object.new
  expect { scanner.backtrack(fake_mark) }.to raise_error(ArgumentError)
end
```

### Use Meaningful Test Data

Make test data intentional and clear:

```ruby
# ✅ Good - intent is clear
let(:greeting) { "hello" }
let(:target) { "world" }
let(:input) { "#{greeting} #{target}" }

# ❌ Bad - arbitrary values
let(:input) { "abc123xyz" }
```

### Comment Complex Expectations

For complex assertions, add comments explaining the expected behavior:

```ruby
it "tracks locations correctly" do
  # Location format: Location(line, column, offset)
  # Input: "hello\n123b456\nworld"

  match = scanner.match_string("hello")
  expect(match.start_location).to eq(Grammy::Location.new(1, 1, 0))  # Start of input
  expect(match.end_location).to eq(Grammy::Location.new(1, 5, 4))    # After "hello"
end
```

## Testing School of Thought

Grammy primarily follows the **Detroit/Classicist school** of TDD:

- Test observable behavior and state
- Use real objects when practical
- Mock only external dependencies or complex collaborators

```ruby
# Detroit school (preferred for Grammy)
it "parses input and returns tokens" do
  result = grammar.parse("hello")
  expect(result.tokens).to eq(["hello"])  # State verification
end
```

Use the **London/Mockist school** only when testing complex interactions:

```ruby
# London school (use sparingly)
it "delegates to scanner for matching" do
  scanner = instance_double(Grammy::Scanner)
  expect(scanner).to receive(:match_string).with("hello")
  grammar.new(scanner).parse("hello")  # Interaction verification
end
```

## Debugging Tests

### Conditional Debugging

Use `ENV['DEBUG']` to enable debug output:

```ruby
it "parses complex input" do
  result = grammar.parse(input)
  pp result if ENV['DEBUG']  # Only prints when DEBUG=1
  expect(result).to be_valid
end
```

Run with debugging:

```bash
DEBUG=1 bundle exec rspec spec/grammar_spec.rb
```


### Focus on Specific Tests

Use `:focus` metadata to run only specific tests:

```ruby
it "parses input", :focus do
  # This test will run exclusively
end
```

Or use `fit`, `fdescribe`, `fcontext`:

```ruby
fit "parses input" do
  # This test will run exclusively
end
```


## Common Patterns

### Testing Parsers

```ruby
RSpec.describe MyGrammar do
  subject(:grammar) { described_class }

  context "with valid input" do
    it "parses successfully" do
      expect(grammar).to parse("x = 42").as(["x = ", "42"])
    end
  end

  context "with invalid input" do
    let(:input) { "invalid" }

    it "raises ParseError" do
      expect(grammar).to fail_to_parse(input)
    end
  end
end
```

### Testing Matchers

```ruby
RSpec.describe Grammy::Matcher::String do
  subject(:matcher) { described_class.new(pattern) }
  let(:pattern) { "hello" }

  it_behaves_like "a matcher" do
    let(:matching_input) { "hello world" }
    let(:non_matching_input) { "goodbye" }
  end

  it "matches exact string" do
    scanner = Grammy::Scanner.new("hello world")
    match = matcher.match(scanner)
    expect(match.text).to eq("hello")
  end
end
```

### Testing Transformations

```ruby
RSpec.describe Grammy::Tree::Transformation do
  subject(:transformer) { transformer_class.new }

  let(:transformer_class) do
    Class.new do
      include Grammy::Tree::Transformation
      transform(:number) { |token| token.with(value: token.text.to_i) }
    end
  end

  it "transforms token text to integer value" do
    token = Grammy::Token.new(:number, "42")
    result = transformer.transform(token)
    expect(result.value).to eq(42)
  end
end
```

## Continuous Improvement

### Code Review Checklist

When reviewing test code, ask:

- [ ] Does the test have a clear, descriptive name?
- [ ] Does it follow the Red-Green-Refactor cycle?
- [ ] Are edge cases covered?
- [ ] Are error conditions tested?
- [ ] Is test data meaningful and intentional?
- [ ] Are there any debugging artifacts (pp, binding.pry)?
- [ ] Could shared examples reduce duplication?
- [ ] Would a custom matcher improve readability?

### Refactoring Tests

Test code deserves the same care as production code:

- Remove duplication with shared examples
- Extract common setup to helper methods
- Use custom matchers for domain concepts
- Keep tests focused and readable


**Remember**: Good tests are the foundation of good code. Test first, test often, test well.
