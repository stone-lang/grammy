# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project attempts to adhere to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.11] - 2025-01-08

### Breaking Changes

- **Location API change**: Renamed attributes for clarity
    - `row` → `line` (more appropriate for source code)
    - `index` → `offset` (clearer parser terminology)
    - `Location.new` now uses `(line, column, offset)` instead of `(row, column, index)`

### Added

- Custom RSpec matchers for more expressive tests
    - `expect(grammar).to parse(input).as(tokens)`
    - `expect(grammar).to fail_to_parse(input)`
    - `expect(parse_tree).to have_tokens(tokens)`
    - `expect(match).to be_at_location(line, col, offset)`
- Comprehensive test suite improvements
    - Scanner edge case tests (empty input, Unicode, Windows line endings, null bytes)
    - Negative test cases for invalid scanner operations
    - Shared examples for matcher behavior
    - Detailed comments explaining location tracking
- Test documentation in `spec/README.md` with TDD guidelines

### Changed

- Improved test descriptions for clarity
- Cleaned up experimental LLVM code from `ast_spec.rb`

### Fixed

- Suppress warnings from pry gem (not yet updated for Ruby 3.4)

## [0.10] - Previous release

(Version 0.10 changes not documented)
