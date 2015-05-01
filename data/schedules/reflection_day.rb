class SundaySchedule < Schedule
  def self.match?(month, day)
    day.sunday? && ! (month.days.last == day)
  end

  # Instance methods.
  def day_title_options
    super.merge(color: '336633')
  end

  def setup
    self.tasks.list('Important', :important)
    self.tasks.list('Errands', :errands)
  end
end

class MonthReflectionDaySchedule < SundaySchedule
  # Last day of a month OR
  # Sunday the 1st if Saturday was the last day of a month.
  def self.match?(month, day)
    month.days.last == day || (month.days[-2] == day && month.days[-2].saturday?)
  end
end
