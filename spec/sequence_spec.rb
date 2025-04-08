require "grammy/matcher/sequence"
require "grammy/scanner"


RSpec.describe Grammy::Matcher::Sequence do

  subject(:matcher) { described_class.new(*matchers) }
  let(:scanner) { Grammy::Scanner.new("abc1234") }
  let(:matchers) {
    [
      Grammy::Matcher.new(/abc/),
      Grammy::Matcher.new(/\d+/)
    ]
  }

  describe "#match" do
    it "returns an array of Match objects with the matched patterns" do
      match_result = matcher.match(scanner)
      expect(match_result).to be_an(Array)
      expect(match_result.first.matched_string).to eq("abc")
      expect(match_result.last.matched_string).to eq("1234")
    end
  end

end
