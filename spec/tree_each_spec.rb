# rubocop:disable RSpec/IndexedLet, Style/MapIntoArray
require "grammy/tree"
require "grammy/token"
require "grammy/match"

RSpec.describe Grammy::Tree do
  let(:leaf1) { Grammy::Token.new(:leaf, Grammy::Match.new("a")) }
  let(:leaf2) { Grammy::Token.new(:leaf, Grammy::Match.new("b")) }
  let(:leaf3) { Grammy::Token.new(:leaf, Grammy::Match.new("c")) }
  let(:tree) do
    described_class.new("root", [
      leaf1,
      described_class.new("child", [leaf2]),
      leaf3
    ])
  end

  describe "#each" do
    it "yields every node in pre-order" do
      nodes = []
      tree.each do |n|
        nodes << n
      end
      expect(nodes).to eq([
        tree,
        leaf1,
        tree.children[1],
        leaf2,
        leaf3
      ])
    end

    it "returns an enumerator if no block is given" do
      enum = tree.each
      expect(enum).to be_an(Enumerator)
      expect(enum.to_a).to eq([
        tree,
        leaf1,
        tree.children[1],
        leaf2,
        leaf3
      ])
    end
  end
end
# rubocop:enable RSpec/IndexedLet, Style/MapIntoArray
