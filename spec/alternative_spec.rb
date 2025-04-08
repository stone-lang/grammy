require "grammy/matcher/alternative"
require "grammy/scanner"


RSpec.describe Grammy::Matcher::Alternative do

  subject(:matcher) { described_class.new(*matchers) }
  let(:scanner) { Grammy::Scanner.new("abc1234") }
  let(:matchers) {
    [
      Grammy::Matcher.new(/\d+/),
      Grammy::Matcher.new(/abc/)
    ]
  }

  describe "#match" do
    it "returns a Match with the matched pattern" do
      match_result = matcher.match(scanner)
      expect(match_result.matched_string).to eq("abc")
    end
  end

end
