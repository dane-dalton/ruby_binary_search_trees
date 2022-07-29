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

  #breadth first search
  def level_order
    #make queue
    queue = []
    queue << @root
    queue.each do |node|
      queue << node.left unless node.left == nil
      queue << node.right unless node.right == nil
      yield node if block_given?
    end

    #return queue
    queue.map { |node| node.data }
  end

  #left, root, right
  def inorder_recursive(root = @root, stack = [])
    return if root == nil
    inorder_recursive(root.left, stack)
    stack << root
    inorder_recursive(root.right, stack)

    stack
  end

  def inorder
    stack = self.inorder_recursive()

    stack.each { |node| yield node } if block_given?

    stack.map { |node| node.data }
  end

  #root, left, right
  def preorder_recursive(root = @root, stack = [])
    return if root == nil
    stack << root
    preorder_recursive(root.left, stack)
    preorder_recursive(root.right, stack)

    stack
  end

  def preorder
    stack = preorder_recursive()

    stack.each { |node| yield node } if block_given?

    stack.map { |node| node.data }
  end

  #left, right, root
  def postorder_recursive(root = @root, stack = [])
    return if root == nil
    postorder_recursive(root.left, stack)
    postorder_recursive(root.right, stack)
    stack << root

    stack
  end

  def postorder 
    stack = postorder_recursive()

    stack.each { |node| yield node } if block_given?

    stack.map { |node| node.data }
  end

  #longest path from node to a leaf
  def height(node)
    return 0 if node == nil
    a = height(node.left)
    b = height(node.right)
    if a > b
      return a + 1
    else
      return b + 1
    end
  end

  def depth(node)
    return 0 if node == @root
    temp = @root
    d = 0
    until node == temp
      if node.data < temp.data
        d += 1
        temp = temp.left
      elsif node.data > temp.data
        d += 1
        temp = temp.right
      else
        return d
      end
    end
    d
  end

  def balanced?(node = @root, array = [])
    if node.left == nil && node.right == nil
      array << depth(node)
    else
      balanced?(node.left, array) unless node.left == nil
      balanced?(node.right, array) unless node.right == nil
    end

    array = array.sort
    return false if ((array[0] - array[-1]).abs() >= 2)
    return true
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

tree = Tree.new()
tree.insert(1)
tree.pretty_print()
tree.pretty_print()
p tree.level_order
p tree.inorder
p tree.preorder
p tree.postorder
p tree.height(tree.find(1))
p tree.depth(tree.find(1))
tree.pretty_print()
p tree.balanced?()