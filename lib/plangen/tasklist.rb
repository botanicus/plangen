class TaskList
  def important
    @important ||= Array.new
  end

  def errands
    @errands ||= Array.new
  end
end
