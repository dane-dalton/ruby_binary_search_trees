class Node
  attr_accessor :data, :left, :right

  def initialize(data = nil)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root, :rand_arr

  def initialize()
    @rand_arr = random_array()
    @root = build_tree(@rand_arr)
  end

  def random_array()
    array = []
    10.times do
      value = rand(100)
      # For simplicities sake, don't use duplicates atm - makes balancing the tree more difficult
      array << value unless array.any?(value)
    end
    array = array.sort
    return array
  end

  def build_tree(array)
    return nil if array.empty?
    mid = (array.length - 1) / 2
    node = Node.new(array[mid])
    node.left = build_tree(array[0...mid])
    node.right = build_tree(array[(mid + 1)..-1])
    return node
  end

  def insert(value)
    return @root = Node.new(value) if @root == nil
    temp = @root
    until temp == nil
      if value >= temp.data
        temp = temp.right
      else
        temp = temp.left
      end
    end
    return temp = Node.new(value)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

tree = Tree.new()
tree.insert(100)
tree.pretty_print()