# Determine Ruby version dynamically, by parsing `.tool-versions` file.
TOOL_VERSIONS_RUBY = File.readlines(File.join(__dir__, ".tool-versions")).grep(/\Aruby\s+/)[0].split[1]
ruby TOOL_VERSIONS_RUBY

source "https://rubygems.org"

# Specifications
gem "rspec"

# Console
gem "irb"
gem "amazing_print"
gem "rainbow" # ANSI colors for the console

# Debugging
gem "debug", ">= 1.0.0"

# Building
gem "overcommit"
gem "rubocop", require: false
gem "rubocop-rspec", require: false
gem "rubocop-performance", require: false
gem "ruby-lsp", require: false
