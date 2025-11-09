# Shared examples for Grammy matchers
#
# Usage:
#   it_behaves_like "a matcher" do
#     let(:matcher) { Grammy::Matcher::String.new("abc") }
#     let(:matching_input) { "abc123" }
#     let(:non_matching_input) { "xyz" }
#   end

RSpec.shared_examples "a matcher" do
  describe "matcher behavior" do
    context "with non-matching input" do
      let(:scanner) { Grammy::Scanner.new(non_matching_input) }

      it "returns nil when no match" do
        expect(matcher.match(scanner)).to be_nil
      end

      it "does not advance scanner position on failed match" do
        mark_before = scanner.mark
        matcher.match(scanner)
        mark_after = scanner.mark
        expect(mark_after).to eq(mark_before)
      end
    end

    context "with matching input" do
      let(:scanner) { Grammy::Scanner.new(matching_input) }

      it "returns a non-nil result on successful match" do
        expect(matcher.match(scanner)).not_to be_nil
      end

      it "advances scanner position on successful match" do
        mark_before = scanner.mark
        matcher.match(scanner)
        mark_after = scanner.mark
        expect(mark_after).not_to eq(mark_before)
      end
    end
  end
end
