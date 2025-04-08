require "grammy/parse_tree"


RSpec.describe Grammy::ParseTree do

  subject(:parse_tree) { nested_tree }

  it "prints, with children indented 4 spaces" do
    expected_output = <<~OUTPUT.strip
      #<ParseTree name="Parent">
          #<ParseTree name="Child 1">
              #<ParseTree name="Grandchild">
          #<ParseTree name="Child 2">
    OUTPUT
    expect(parse_tree.to_s).to eq(expected_output)
  end

  def nested_tree
    Grammy::ParseTree.new("Parent") {
      [
        Grammy::ParseTree.new("Child 1") {
          Grammy::ParseTree.new("Grandchild")
        },
        Grammy::ParseTree.new("Child 2")
      ]
    }
  end

end
