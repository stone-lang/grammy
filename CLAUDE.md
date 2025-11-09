# Grammy Project Guide

## Commands

- `bundle exec rspec`: Run all tests
- `bundle exec rspec spec/path/to/spec_file.rb`: Run a specific test file
- `bundle exec rspec spec/path/to/spec_file.rb:LINE_NUMBER`: Run a specific test (example)
- `bundle exec rubocop`: Run code style checks
- `bundle exec rubocop -a`: Auto-correct style issues where possible

## Code Style Guidelines

- Follow RuboCop rules (.rubocop.yml) which inherits from https://raw.githubusercontent.com/booch/config_files/master/ruby/rubocop.yml
- Use semantic block delimiters: `{}` for blocks that return values, `do/end` for procedural blocks
- Line length: Max 160 characters
- Naming: Snake case for methods/variables, camel case for classes/modules
- Module structure: Don't require empty lines between class/module body definitions
- Documentation: Document public API methods
- Error handling: Use explicit exceptions with descriptive messages
- RSpec: Up to 10 expectations per example allowed

## Project Info

- Ruby target version: 3.4
- Test framework: RSpec
- Build tools: Bundler

## Commit Messages

When creating commits for work done with AI assistance, add a co-author trailer to the commit message, similar to pair programming convention:

```
Co-authored-by: Claude (Anthropic) <claude@anthropic.com>
```

GitHub will recognize the `Co-authored-by:` trailer and show both authors on the commit.

## Issue Tracking

**IMPORTANT**: When you encounter warnings, deprecations, or other issues during your work that are outside the scope of your current task, add them to ISSUES.md and mention them to the user.
