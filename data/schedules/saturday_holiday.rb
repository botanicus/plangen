class SaturdaySchedule < Schedule
  def self.match?(month, day)
    day.saturday?
  end

  # Instance methods.
  def day_title_options
    super.merge(color: '330099')
  end

  def setup
    self.tasks.list('Important', :important)

    # Do bigger shopping on the first Saturday of any month.
    if self.day.day <= 6
      self.tasks.important.push('Shopping for clothes and bigger items (including on Amazon).')
      # TODO: Always stick to a theme. Skinny ties or so.
    end

    self.tasks.important.push('Buy food for the next week.')
  end
end

class HolidaySchedule < SaturdaySchedule
  def self.match?(month, day)
    day.bank_holiday? && ! day.weekend?
  end

  # Instance methods.
  def day_title
    "#{super} #{day.bank_holiday}"
  end
end
