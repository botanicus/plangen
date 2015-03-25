require 'forwardable'

# list = TaskList.new
# # Define the lists. First defined will come in first in the output.
# list.list('20 MM', :twenty_miles_march)
# list.list('Lunch Break', :lunchbreak)
class TaskList
  def list(label, name, min_number_of_items = 1)
    # To preserve the order.
    self.lists << [label, name]

    group = TaskGroup.new(min_number_of_items)
    self.instance_variable_set(:"@#{name}", group)
    self.class.send(:define_method, name) do
      self.instance_variable_get(:"@#{name}")
    end
  end

  def lists
    @lists ||= Array.new
  end

  def each(&block)
    return enum_for(:each) unless block

    self.lists.each do |label, name|
      items = self.send(name)
      block.call(label, items.each.to_a)
    end
  end
end

# Like an array, but ensures there's at least n items in the collection.
# @api private This is not exposed anywhere. See TaskList#each.
# TODO: Maybe this could be a mixing to be called on an instance of arrays
# like items.extend(PopulatedEachMixin) or something like that.
class TaskGroup
  extend Forwardable

  def_delegator :@items, :push
  def_delegator :@items, :<<
  def_delegator :@items, :unshift

  def initialize(min_number_of_items = 1)
    @min_number_of_items = min_number_of_items
    @items = Array.new
  end

  def each(&block)
    return enum_for(:each) unless block

    if @items.length < @min_number_of_items
      items = @items.dup.fill(nil, @items.length, @min_number_of_items - @items.length)
      items.each { |item| block.call(item) }
    else
      @items.each { |item| block.call(item) }
    end
  end
end
