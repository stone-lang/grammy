# frozen_string_literal: true

require "rake/testtask"
require "bundler/gem_tasks"

# RSpec task
desc "Run RSpec tests"
task :spec do
  sh "bundle exec rspec"
end

desc "Run all tests"
task test: :spec

desc "Build the gem package"
task :build do
  sh "gem build grammy.gemspec"
end

desc "Install the gem locally"
task install: :build do
  gem_file = Dir["grammy-*.gem"].sort.last
  sh "gem install #{gem_file}"
end

desc "Release the gem (build, push to rubygems.org)"
task release: :build do
  gem_file = Dir["grammy-*.gem"].sort.last
  sh "gem push #{gem_file}"
end
