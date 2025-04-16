require "grammy/parse_tree"


RSpec.describe Grammy::ParseTree do

  subject(:parse_tree) { nested_tree }

  describe "#to_s" do
    it "prints with children indented 4 spaces" do
      expected_output = <<~OUTPUT.strip
        #<ParseTree "Parent">
            String Child
            #<ParseTree "Child 1">
                #<ParseTree "Grandchild">
                String Grandchild
            #<ParseTree "Child 2">
      OUTPUT
      expect(parse_tree.to_s).to eq(expected_output)
    end
  end

  def nested_tree # rubocop:disable Metrics/MethodLength
    Grammy::ParseTree.new("Parent") {
      [
        "String Child",
        Grammy::ParseTree.new("Child 1") {
          [
            Grammy::ParseTree.new("Grandchild"),
            "String Grandchild"
          ]
        },
        Grammy::ParseTree.new("Child 2")
      ]
    }
  end

end
