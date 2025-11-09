require "grammy/matcher/alternative"
require "grammy/scanner"


RSpec.describe Grammy::Matcher::Alternative do

  subject(:matcher) { described_class.new(*alternatives) }
  let(:alternatives) {
    [
      Grammy::Matcher::Regexp.new(/\d+/),
      Grammy::Matcher::Regexp.new(/abc/)
    ]
  }
  let(:scanner) { Grammy::Scanner.new(input) }
  let(:input) { "abc1234" }
  let(:match_result) { matcher.match(scanner) }

  it_behaves_like "a matcher" do
    let(:matching_input) { "abc1234" }
    let(:non_matching_input) { "xyz" }
  end

  describe "#match" do
    it "returns a Token with the matched pattern" do
      expect(match_result.text).to eq("abc")
    end

    context "when none of the alternatives match" do
      let(:input) { "no matches" }

      it "fails (returns nil)" do
        expect(match_result).to be_nil
      end
    end

  end
end
