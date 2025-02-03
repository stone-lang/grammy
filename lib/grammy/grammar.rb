require "grammy"
require "grammy/combinators"
require "grammy/scanner"

module Grammy

  class Grammar
    include Grammy::Combinators

    attr_reader :scanner

    def self.start(name = nil)
      if name
        @start = name
      else
        @start
      end
    end

    def self.rule(name, &block)
      rules[name] = block
    end

    def self.rules
      @rules ||= {}
    end

    def initialize(scanner)
      @scanner = scanner
    end

    def start
      self.class.start || fail(NotImplementedError, "No start rule defined")
    end

    def rules
      self.class.rules
    end
  end
end
