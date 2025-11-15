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

    context "when an alternative returns an empty ParseTree" do
      let(:empty_tree_matcher) do
        double("EmptyTreeMatcher", match: Grammy::ParseTree.new(:empty_rule, []))
      end
      let(:alternatives) { [empty_tree_matcher, Grammy::Matcher::Regexp.new(/abc/)] }
      let(:input) { "abc" }

      it "tries the next alternative and succeeds" do
        expect(match_result).not_to be_nil
        expect(match_result.text).to eq("abc")
      end
    end

  end
end
