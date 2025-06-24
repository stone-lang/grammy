require "grammy/tree"
require "grammy/token"
require "grammy/match"


# rubocop:disable Metrics/ModuleLength
module Grammy
  RSpec.describe Tree do
    let(:empty_tree) { described_class.new("Empty") }
    let(:simple_tree) { described_class.new("Simple", [leaf_first, leaf_second]) }
    let(:nested_tree) {
      described_class.new("Parent") {
        [
          leaf_first,
          described_class.new("Child 1") {
            [
              described_class.new("Grandchild"),
              "Nested Leaf"
            ]
          },
          described_class.new("Child 2")
        ]
      }
    }

    let(:leaf_first) { Token.new(:leaf, Match.new("First Leaf")) }
    let(:leaf_second) { Token.new(:leaf, Match.new("world")) }

    describe ".new" do
      it "creates a tree with a name and children" do
        expect(simple_tree.name).to eq("Simple")
        expect(simple_tree.children).to eq([leaf_first, leaf_second])
      end

      it "accepts a block for nested creation" do
        expect(nested_tree.name).to eq("Parent")
        expect(nested_tree.children.first).to eq(leaf_first)
        expect(nested_tree.children[1].children[1]).to eq("Nested Leaf")
      end

      it "wraps a single child in array" do
        tree = described_class.new("root", leaf_first)
        expect(tree.children).to eq([leaf_first])
      end
    end

    describe "#empty?" do
      it "returns true when there are no children" do
        tree = described_class.new("root", [])
        expect(tree).to be_empty
      end

      it "returns true when children are nil or empty" do
        tree = described_class.new("root", [nil, []])
        expect(tree).to be_empty
      end

      it "returns false when there are children" do
        tree = described_class.new("root", [leaf_first])
        expect(tree).not_to be_empty
      end
    end

    describe "#leaves" do
      it "returns leaf nodes from a flat tree" do
        tree = described_class.new("root", [leaf_first, leaf_second])
        expect(tree.leaves).to eq([leaf_first, leaf_second])
      end

      it "returns leaf nodes from a nested tree" do
        nested = described_class.new("child", [leaf_second])
        tree = described_class.new("root", [leaf_first, nested])
        expect(tree.leaves).to eq([leaf_first, leaf_second])
      end

      it "filters out nil values" do
        tree = described_class.new("root", [leaf_first, nil, leaf_second])
        expect(tree.leaves).to eq([leaf_first, leaf_second])
      end
    end

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

    describe "#to_s" do
      it "formats a simple tree" do
        tree = described_class.new("root", [leaf_first])
        expected = "root\n    #{leaf_first}"
        expect(tree.to_s).to eq(expected)
      end

      it "formats a nested tree" do
        expected_output = <<~OUTPUT.strip
          Parent
              First Leaf
              Child 1
                  Grandchild
                  Nested Leaf
              Child 2
        OUTPUT
        expect(nested_tree.to_s).to eq(expected_output)
      end
    end

    describe "#to_h" do
      it "converts a simple tree to hash" do
        tree = described_class.new("root", [leaf_first])
        expect(tree.to_h).to eq({
                                  name: "root",
                                  children: [leaf_first.to_h]
                                })
      end

      it "converts a nested tree to hash" do
        nested = described_class.new("child", [leaf_first])
        tree = described_class.new("root", [nested])
        expect(tree.to_h).to eq({
                                  name: "root",
                                  children: [
                                    {
                                      name: "child",
                                      children: [leaf_first.to_h]
                                    }
                                  ]
                                })
      end
    end
  end
end

# rubocop:enable Metrics/ModuleLength
