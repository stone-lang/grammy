require "spec_helper"
require "stringio"

require "grammy/scanner"

RSpec.describe Grammy::Scanner do
  subject(:scanner) { described_class.new(input) }
  let(:input) { "hello\n123b456\nworld" }

  context "with IO input" do
    let(:input) { StringIO.new("abc") }

    it "also works" do
      expect(scanner.match("a").matched_string).to eq("a")
    end
  end

  describe "#match with a string" do
    it "returns nil when string does not match" do
      expect(scanner.match("world")).to be_nil
    end

    it "matches literal string" do
      match = scanner.match("hello")
      expect(match.matched_string).to eq("hello")
    end

    it "does not advance position on failed literal match" do
      failed_match = scanner.match("x")
      expect(failed_match).to be_nil
      match = scanner.match("hello")
      expect(match.matched_string).to eq("hello")
    end
  end

  describe "match with a regex" do
    it "returns nil when regex does not match" do
      expect(scanner.match(/\d+/)).to be_nil
    end

    it "matches regex" do
      scanner.match("hello\n")
      match = scanner.match(/\d+/)
      expect(match.matched_string).to eq("123")
    end
  end

  describe "position tracking" do
    it "tracks positions correctly, even across linefeeds" do
      match1 = scanner.match("hello")
      expect(match1.start_position).to eq(Grammy::Position.new(1, 1, 0))
      expect(match1.end_position).to eq(Grammy::Position.new(1, 5, 4))

      newline = scanner.match("\n")
      expect(newline.start_position).to eq(Grammy::Position.new(1, 6, 5))
      expect(newline.end_position).to eq(Grammy::Position.new(1, 6, 5))

      match2 = scanner.match(/\d+b\d+/)
      expect(match2.start_position).to eq(Grammy::Position.new(2, 1, 6))
      expect(match2.end_position).to eq(Grammy::Position.new(2, 7, 12))

      match3 = scanner.match("\nworld")
      expect(match3.start_position).to eq(Grammy::Position.new(2, 8, 13))
      expect(match3.end_position).to eq(Grammy::Position.new(3, 5, 18))
    end
  end

  describe "backtracking" do
    it "can set scanning position back to mark" do
      mark = scanner.mark
      scanner.match("hello")
      scanner.match("\n123")
      scanner.backtrack(mark)
      match = scanner.match("hello")
      expect(match.matched_string).to eq("hello")
    end

    it "can consume mark so backtracking is limited" do
      mark = scanner.mark
      scanner.match("hello")
      scanner.consume(mark)
      expect { scanner.backtrack(mark) }.to raise_error(ArgumentError)
    end

    it "supports nested marks" do
      outer = scanner.mark
      scanner.match("hello")
      inner = scanner.mark
      scanner.match("\n123")
      scanner.backtrack(inner)
      scanner.match("\n123")
      scanner.match("b456")
      scanner.backtrack(outer)
      match = scanner.match("hello")
      expect(match.matched_string).to eq("hello")
    end

    it "cannot consume a mark twice" do
      mark = scanner.mark
      scanner.consume(mark)
      expect { scanner.consume(mark) }.to raise_error(ArgumentError)
    end

    it "cannot consume outer mark without consuming inner mark first" do
      outer = scanner.mark
      scanner.match("hello")
      _inner = scanner.mark
      scanner.match("\n123")
      expect { scanner.consume(outer) }.to raise_error(ArgumentError)
    end

  end
end
