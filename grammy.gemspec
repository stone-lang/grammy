Gem::Specification.new do |spec|
  spec.name          = "grammy"
  spec.version       = File.read("VERSION")
  spec.authors       = ["Craig Buchek"]
  spec.email         = ["craig@boochtek.com"]

  spec.summary       = "A PEG parsing library with a simple DSL"
  spec.description   = "Grammy is a parser with a simple DSL to define the grammar and tree transformations."
  spec.homepage      = "https://github.com/stone-lang/grammy"
  spec.license       = "MIT"
  spec.platform      = Gem::Platform::RUBY
  spec.required_ruby_version = ">= 3.4"

  spec.files         = Dir["lib/**/*"]
  spec.require_paths = ["lib"]

  spec.extra_rdoc_files = Dir["docs/**/*"] + ["README.md"]

  spec.metadata["changelog_uri"] = "https://github.com/stone-lang/grammy/blob/main/docs/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"
end
