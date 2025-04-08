require "grammy/matcher"
require "grammy/scanner"


RSpec.describe Grammy::Matcher do

  subject(:matcher) { described_class.new(pattern) }
  let(:pattern) { /abc/ }
  let(:scanner) { Grammy::Scanner.new("abcdef") }

  describe "#match" do
    it "returns a Matcher with the matched pattern" do
      expect(matcher.match(scanner).matched_string).to eq("abc")
    end
  end

end
