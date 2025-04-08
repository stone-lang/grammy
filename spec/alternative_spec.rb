require "grammy/matcher/alternative"
require "grammy/scanner"


RSpec.describe Grammy::Matcher::Alternative do

  subject(:matcher) { described_class.new(*alternatives) }
  let(:alternatives) {
    [
      Grammy::Matcher.new(/\d+/),
      Grammy::Matcher.new(/abc/)
    ]
  }
  let(:scanner) { Grammy::Scanner.new(input) }
  let(:input) { "abc1234" }
  let(:match_result) { matcher.match(scanner) }

  describe "#match" do
    it "returns a Match with the matched pattern" do
      expect(match_result.matched_string).to eq("abc")
    end

    context "when none of the alternatives match" do
      let(:input) { "no matches" }

      it "fails (returns nil)" do
        expect(match_result).to be_nil
      end
    end

  end
end
