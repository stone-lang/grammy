require "grammy/tree"


module Grammy
  class ParseTree < Tree
    # Turns out that there's not much special about a ParseTree.

    def tokens = leaves.flatten.reject { it.text.nil? }

  end
end
