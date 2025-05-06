require "grammy/matcher"
require "grammy/scanner"


RSpec.describe Grammy::Matcher do

  subject(:matcher) { described_class.new(pattern) }
  let(:pattern) { /abc/ }
  let(:scanner) { Grammy::Scanner.new(input) }
  let(:input) { "abcdef" }
  let(:match_result) { matcher.match(scanner) }

  describe "#match" do
    it "returns a Matcher with the matched pattern" do
      expect(match_result.text).to eq("abc")
    end

    context "when there is no match" do
      let(:input) { "no matches" }

      it "fails (returns nil)" do
        expect(match_result).to be_nil
      end
    end

  end
end
