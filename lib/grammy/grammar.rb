require "grammy"
require "grammy/scanner"

module Grammy

  class Grammar
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

    protected def match(pattern)
      scanner.match(pattern)
    end

    protected def sequence(*children)
      start_pos = scanner.pos
      results = []
      children.each do |child|
        result = child
        return scanner.backtrack(start_pos) unless result
        results << result
      end
    end

  end
end
