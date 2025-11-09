require "stringio"

require "grammy/scanner"


RSpec.describe Grammy::Scanner do

  subject(:scanner) { described_class.new(input) }
  let(:input) { "hello\n123b456\nworld" }

  context "with IO input" do
    let(:input) { StringIO.new("abc") }

    it "also works" do
      expect(scanner.match_string("a").text).to eq("a")
    end
  end

  describe "#match with a string" do
    it "returns nil when string does not match" do
      expect(scanner.match_string("world")).to be_nil
    end

    it "matches literal string" do
      match = scanner.match_string("hello")
      expect(match.text).to eq("hello")
    end

    it "does not advance location on failed literal match" do
      failed_match = scanner.match_string("x")
      expect(failed_match).to be_nil
      match = scanner.match_string("hello")
      expect(match.text).to eq("hello")
    end
  end

  describe "match with a regex" do
    it "returns nil when regex does not match" do
      expect(scanner.match_regexp(/\d+/)).to be_nil
    end

    it "matches regex" do
      scanner.match_string("hello\n")
      match = scanner.match_regexp(/\d+/)
      expect(match.text).to eq("123")
    end
  end

  describe "location tracking" do
    it "tracks locations correctly, even across linefeeds" do
      # Location format: Location(line, column, offset)
      # Input: "hello\n123b456\nworld"

      match1 = scanner.match_string("hello")
      expect(match1.start_location).to eq(Grammy::Location.new(1, 1, 0))    # Start of input
      expect(match1.end_location).to eq(Grammy::Location.new(1, 5, 4))      # After "hello" (5 chars, last at offset 4)

      newline = scanner.match_string("\n")
      expect(newline.start_location).to eq(Grammy::Location.new(1, 6, 5))   # After "hello" at column 6
      expect(newline.end_location).to eq(Grammy::Location.new(1, 6, 5))     # Newline is zero-width for column tracking

      match2 = scanner.match_regexp(/\d+b\d+/)
      expect(match2.start_location).to eq(Grammy::Location.new(2, 1, 6))    # Start of line 2
      expect(match2.end_location).to eq(Grammy::Location.new(2, 7, 12))     # After "123b456" (7 chars)

      match3 = scanner.match_string("\nworld")
      expect(match3.start_location).to eq(Grammy::Location.new(2, 8, 13))   # After "123b456" at column 8
      expect(match3.end_location).to eq(Grammy::Location.new(3, 5, 18))     # After crossing newline to "world"
    end
  end

  describe "backtracking" do
    it "can set scanning location back to mark" do
      mark = scanner.mark
      scanner.match_string("hello")
      scanner.match_string("\n123")
      scanner.backtrack(mark)
      match = scanner.match_string("hello")
      expect(match.text).to eq("hello")
    end

    it "can consume mark so backtracking is limited" do
      mark = scanner.mark
      scanner.match_string("hello")
      scanner.consume(mark)
      expect { scanner.backtrack(mark) }.to raise_error(ArgumentError)
    end

    it "supports nested marks" do
      outer = scanner.mark
      scanner.match_string("hello")
      inner = scanner.mark
      scanner.match_string("\n123")
      scanner.backtrack(inner)
      scanner.match_string("\n123")
      scanner.match_string("b456")
      scanner.backtrack(outer)
      match = scanner.match_string("hello")
      expect(match.text).to eq("hello")
    end

    it "cannot consume a mark twice" do
      mark = scanner.mark
      scanner.consume(mark)
      expect { scanner.consume(mark) }.to raise_error(ArgumentError)
    end

    it "cannot consume outer mark without consuming inner mark first" do
      outer = scanner.mark
      scanner.match_string("hello")
      _inner = scanner.mark
      scanner.match_string("\n123")
      expect { scanner.consume(outer) }.to raise_error(ArgumentError)
    end

    it "raises error when backtracking to consumed mark" do
      mark = scanner.mark
      scanner.match_string("hello")
      scanner.consume(mark)
      expect { scanner.backtrack(mark) }.to raise_error(ArgumentError, /can only backtrack the top mark/)
    end

    it "raises error when backtracking with invalid mark" do
      fake_mark = Object.new
      expect { scanner.backtrack(fake_mark) }.to raise_error(ArgumentError)
    end

    it "raises error when consuming invalid mark" do
      fake_mark = Object.new
      expect { scanner.consume(fake_mark) }.to raise_error(ArgumentError)
    end
  end

  describe "edge cases" do
    context "with empty input" do
      let(:input) { "" }

      it "returns nil for string match" do
        expect(scanner.match_string("x")).to be_nil
      end

      it "returns nil for regexp match" do
        expect(scanner.match_regexp(/./)).to be_nil
      end
    end

    context "with Unicode characters" do
      let(:input) { "héllo wörld" }

      it "matches Unicode strings correctly" do
        match = scanner.match_string("héllo")
        expect(match.text).to eq("héllo")
      end

      it "tracks location correctly with multi-byte characters" do
        match = scanner.match_string("héllo")
        # Location: row, column, and index all use character positions (not bytes)
        # "héllo" is 5 characters (index 0-4), even though é is 2 bytes in UTF-8
        expect(match.start_location).to eq(Grammy::Location.new(1, 1, 0))
        expect(match.end_location).to eq(Grammy::Location.new(1, 5, 4)) # Row 1, col 5, index of last char is 4
      end
    end

    context "with Windows line endings" do
      let(:input) { "hello\r\nworld" }

      it "handles \\r\\n as line separator" do
        scanner.match_string("hello")
        newline = scanner.match_regexp(/\r?\n/)
        expect(newline.text).to match(/\r?\n/)
        match = scanner.match_string("world")
        expect(match.start_location.line).to eq(2)
      end
    end

    context "with null bytes" do
      let(:input) { "hel\x00lo" }

      it "treats null bytes as regular characters" do
        match = scanner.match_string("hel\x00lo")
        expect(match.text).to eq("hel\x00lo")
      end
    end
  end

end
