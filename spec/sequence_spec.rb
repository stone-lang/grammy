require "grammy/matcher/sequence"
require "grammy/scanner"


RSpec.describe Grammy::Matcher::Sequence do

  subject(:matcher) { described_class.new(*submatchers) }
  let(:submatchers) {
    [
      Grammy::Matcher::Regexp.new(/abc/),
      Grammy::Matcher::Regexp.new(/\d+/)
    ]
  }
  let(:scanner) { Grammy::Scanner.new(input) }
  let(:input) { "abc1234" }
  let(:match_result) { matcher.match(scanner) }

  describe "#match" do
    it "returns an array of Token objects with the matched patterns" do
      expect(match_result).to be_an(Array)
      expect(match_result.first.text).to eq("abc")
      expect(match_result.last.text).to eq("1234")
    end

    context "when any part of the sequence does not match" do
      let(:input) { "abc, but not a full match" }

      it "fails (returns nil)" do
        expect(match_result).to be_nil
      end

      it "restores scanner position on failure" do
        initial_position = scanner.location.offset
        matcher.match(scanner)
        expect(scanner.location.offset).to eq(initial_position)
      end

      it "properly cleans up mark stack on failure" do
        matcher.match(scanner)
        expect(scanner.instance_variable_get(:@marks)).to be_empty
      end
    end

    context "when sequence matches successfully" do
      let(:input) { "abc123" }

      it "properly cleans up mark stack on success" do
        expect { matcher.match(scanner) }.not_to raise_error
        expect(scanner.instance_variable_get(:@marks)).to be_empty
      end
    end

  end
end
