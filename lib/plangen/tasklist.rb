# list = TaskList.new
# # Define the lists. First defined will come in first in the output.
# list.list('20 MM', :twenty_miles_march)
# list.list('Lunch Break', :lunchbreak)
class TaskList
  def list(label, name)
    # To preserve the order.
    self.lists << [label, name]

    self.instance_variable_set(:"@#{name}", Array.new)
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
      block.call(label, items)
    end
  end
end
