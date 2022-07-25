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
        return temp.right = Node.new(value) if temp.right == nil
        temp = temp.right
      else
        return temp.left = Node.new(value) if temp.left == nil
        temp = temp.left
      end
    end
  end

  def delete(value, node = @root)
    return node if node == nil

    if value < node.data
      node.left = delete(value, node.left)
    elsif value > node.data
      node.right = delete(value, node.right)
    else
      if node.left == nil
        temp = node.right
        node = nil
        return temp
      elsif node.right == nil
        temp = node.left
        node = nil
        return temp
      end

      temp = node.right
      until temp.left == nil
        temp = temp.left
      end

      node.data = temp.data

      node.right = delete(temp.data, node.right)
    end

    return node
    #If node has no children, simply delete it
    #If node has one child, its parent points to the child then the node is deleted
    #If node has two children, find next biggest value and replace with that value
    ###Node being replaced should have no left child, and if it has a right, then its parent points to its right node before it replaces the desired value
  end

  def find(value)
    return @root if value == @root.data
    temp = @root
    until value == temp.data
      if value < temp.data
        temp = temp.left
      else
        temp = temp.right
      end
    end
    return temp
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

tree = Tree.new()
tree.insert(1)
tree.insert(2)
tree.insert(3)
tree.insert(33)
tree.insert(50)
tree.insert(51)
tree.insert(52)
tree.insert(47)
tree.insert(55)
tree.pretty_print()
tree.delete(50)
tree.pretty_print()
p tree.find(47)