require "grammy/matcher/repetition"
require "grammy/scanner"


# rubocop:disable RSpec/NestedGroups
RSpec.describe Grammy::Matcher::Repetition do

  subject(:matcher) { described_class.new(submatcher, count_range) }
  let(:submatcher) { Grammy::Matcher.new(/\d+x/) }
  let(:scanner) { Grammy::Scanner.new(input) }
  let(:input) { "1234x5678x4321x" }
  let(:match_result) { matcher.match(scanner) }

  describe "#match" do

    context "with 0..1 repetitions allowed" do

      let(:count_range) { 0..1 }

      it "returns an **array of 1** Token object, with the matched pattern" do
        expect(match_result.length).to eq(1)
        expect(match_result.first.matched_string).to eq("1234x")
      end

      context "when the submatcher does not match" do
        let(:input) { "no matches" }

        it "returns an **empty array**" do
          expect(match_result).to be_empty
        end
      end
    end

    context "with 0.. repetitions allowed" do

      let(:count_range) { 0.. }

      it "returns an array of Token objects with the matched patterns" do
        expect(match_result.length).to be(3)
        # binding.pry
        expect(match_result.map(&:matched_string)).to eq(["1234x", "5678x", "4321x"])
      end

      context "when the submatcher does not match" do
        let(:input) { "no matches" }

        it "returns an **empty array**" do
          expect(match_result).to be_empty
        end
      end
    end

    context "with 1.. repetitions allowed" do

      let(:count_range) { 1.. }

      it "returns an array of Token objects with the matched patterns" do
        expect(match_result.length).to eq(3)
        expect(match_result.map(&:matched_string)).to eq(["1234x", "5678x", "4321x"])
      end

      context "when the submatcher does not match" do
        let(:input) { "no matches" }

        it "fails (returns nil)" do
          expect(match_result).to be_nil
        end
      end
    end

  end
end
# rubocop:enable RSpec/NestedGroups
