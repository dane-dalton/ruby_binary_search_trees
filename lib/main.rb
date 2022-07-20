class Node
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root, :rand_arr

  def initialize()
    @rand_arr = random_array()
    @root = self.build_tree(rand_arr, 0, rand_arr.length - 1)
  end

  def random_array()
    array = []
    10.times do
      value = rand(100)
      # For simplicities sake, don't use duplicates atm - makes balancing the tree more difficult
      array << value unless array.any?(value)
    end
    return array
  end

  def build_tree(array, start, end_element)
    return nil if start > end_element
    mid = (end_element - start) / 2
    @root = Node.new(array[mid]) if @root == nil
    temp = @root
    p temp
    p array
    temp.left = build_tree(array, start, mid - 1)
    temp.right = build_tree(array, mid + 1, end_element)

    return Node.new(array[mid])
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

tree = Tree.new()
tree.pretty_print