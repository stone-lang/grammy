require "grammy"
require "grammy/combinators"
require "grammy/scanner"
require "grammy/refinements"

module Grammy

  class Grammar
    include Grammy::Combinators

    attr_reader :scanner

    def self.start(name = nil)
      @start = name if name
      @start
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
      self.class.start || fail(Grammy::ParseError, "Start rule not defined for #{self.class}")
    end

    def start_rule
      self.class.rules[start]
    end

    def rules
      self.class.rules
    end
  end
end
