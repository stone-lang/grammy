require "rspec"
require "scanner"

RSpec.describe Scanner do
  subject(:scanner) { described_class.new(input) }
  let(:input) { "hello world" }


  describe "#match" do
    context "when matching a literal string" do
      it "matches the literal at the beginning of the input" do
        match = scanner.match("hello")
        expect(match).not_to be_nil
        expect(match.matched_string).to eq("hello")
        expect(match.start_position).to eq(Position.new(1, 1, 0))
        expect(match.end_position).to eq(Position.new(1, 1 + "hello".length, "hello".length))
      end

      it "returns nil if the literal does not match at the current position" do
        result = scanner.match("world")
        expect(result).to be_nil
      end

      it "advances the scanner position after a successful match" do
        scanner.match("hello")
        expect(scanner.current_index).to eq(5)
      end

      it "does not advance the scanner position if the match fails" do
        pos_before = scanner.current_index
        result = scanner.match("not")
        expect(result).to be_nil
        expect(scanner.current_index).to eq(pos_before)
      end
    end

    context "when matching using a regex" do
      it "matches a regex pattern and returns the correct Match object" do
        match = scanner.match(/\w+/)
        expect(match).not_to be_nil
        expect(match.matched_string).to eq("hello")
        expect(match.start_position).to eq(Position.new(1, 1, 0))
        expect(match.end_position).to eq(Position.new(1, 6, 5))
      end

      it "returns nil if the regex does not match the current input" do
        scanner.match("hello")
        result = scanner.match(/world/)
        expect(result).to be_nil
      end
    end
  end

  describe "position tracking" do
    context "with multi-line input" do
      subject(:scanner) { described_class.new(input) }
      let(:input) { "line1\nline2" }


      it "correctly tracks positions for a single line match" do
        match = scanner.match(/line1/)
        expect(match.start_position).to eq(Position.new(1, 1, 0))
        expect(match.end_position).to eq(Position.new(1, 6, 5))
      end

      it "correctly updates row, column, and index for multi-line matches" do
        match1 = scanner.match(/line1/)
        expect(match1.start_position).to eq(Position.new(1, 1, 0))
        expect(match1.end_position).to eq(Position.new(1, 6, 5))

        newline = scanner.match("\n")
        expect(newline.matched_string).to eq("\n")
        expect(newline.start_position).to eq(Position.new(1, 6, 5))
        expect(newline.end_position).to eq(Position.new(2, 1, 6))

        match2 = scanner.match(/line2/)
        expect(match2.start_position).to eq(Position.new(2, 1, 6))
        expect(match2.end_position).to eq(Position.new(2, 6, 11))
      end
    end
  end

  describe "backtracking with mark/rollback/commit" do
    it "supports mark and rollback to revert consumed input" do
      initial_index = scanner.current_index
      scanner.mark
      match = scanner.match("hello")
      expect(match).not_to be_nil
      expect(scanner.current_index).to eq(initial_index + 5)
      scanner.rollback
      expect(scanner.current_index).to eq(initial_index)
    end

    it "supports commit to confirm consumption and disable rollback" do
      scanner.mark
      match = scanner.match("hello")
      expect(match).not_to be_nil
      scanner.commit
      scanner.rollback
      expect(scanner.current_index).to eq(5)
    end

    it "allows nested marks and corresponding rollbacks" do
      scanner.mark
      scanner.match("hello")
      first_mark_index = scanner.current_index

      scanner.mark
      scanner.match(" ")
      expect(scanner.current_index).to eq(first_mark_index + 1)

      scanner.rollback
      scanner.rollback
      expect(scanner.current_index).to eq(0)
    end
  end
end
