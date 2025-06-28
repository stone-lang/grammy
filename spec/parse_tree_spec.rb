require "grammy/parse_tree"
require "grammy/token"
require "grammy/match"


module Grammy
  RSpec.describe ParseTree do

    let(:leaf_first) { Token.new(:leaf, Match.new("First Leaf")) }
    let(:leaf_second) { Token.new(:leaf, Match.new("world")) }

    describe "#tokens" do
      it "returns matched strings from all leaves" do
        tree = described_class.new("root", [leaf_first, leaf_second])
        expect(tree.tokens.map(&:to_s)).to eq(["First Leaf", "world"])
      end

      it "returns tokens from nested trees" do
        nested = described_class.new("child", [leaf_second])
        tree = described_class.new("root", [leaf_first, nested])
        expect(tree.tokens.map(&:to_s)).to eq(["First Leaf", "world"])
      end
    end

  end
end
