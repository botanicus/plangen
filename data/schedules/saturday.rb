class SaturdaySchedule < Schedule
  HEADER_COLOUR = '330099'

  def self.match?(month, day)
    day.saturday?
  end

  def setup
    self.tasks.list('Important', :important)

    # Do bigger shopping on the first Saturday of any month.
    if self.day.day <= 6
      self.tasks.important.push('Shopping for clothes and bigger items (including on Amazon).')
    end

    self.tasks.important.push('Buy food for the next week.')
  end
end
