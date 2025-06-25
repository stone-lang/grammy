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
    end

  end
end
