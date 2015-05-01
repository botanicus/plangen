class OfficeWorkdaySchedule < Schedule
  HEADER_COLOUR = 'ff0000'

  def self.match?(month, day)
    false
  end

  def setup
    self.tasks.list('20 MM', :twenty_miles_march, 1)
    self.tasks.list('Lunch Break', :lunchbreak, 3)
    self.tasks.list('Evening', :evening, 3)
  end
end

class OfficeMondaySchedule < OfficeWorkdaySchedule
  def self.match?(month, day)
    day.workday? && day.monday?
  end
end

class OfficeTuesdaySchedule < OfficeWorkdaySchedule
  def self.match?(month, day)
    day.workday? && day.tuesday?
  end

  def setup
    super

    self.tasks.lunchbreak.push('Go swimming.')
  end
end

class OfficeWednesdaySchedule < OfficeWorkdaySchedule
  def self.match?(month, day)
    day.workday? && day.wednesday?
  end

  def setup
    super

    self.tasks.lunchbreak.push('Write a blog post.')
  end
end

class OfficeThursdaySchedule < OfficeWorkdaySchedule
  def self.match?(month, day)
    day.workday? && day.thursday?
  end

  def setup
    super

    self.tasks.lunchbreak.push('Go swimming.')

    # TODO: Where to put this? schedule? Elsewhere?
    # TODO: Make this_week etc area accessible.
    # Merge schedule & tasks?
    self.tasks.lunchbreak.unshift('Fasting.')
    self.tasks.evening.push('Relax at the evening. Go to bed early.')
  end
end

class OfficeFridaySchedule < OfficeWorkdaySchedule
  def self.match?(month, day)
    day.workday? && day.friday?
  end

  def setup
    super

    # Do I need .dup?
    self.schedule_items.delete('21:00')
    self.schedule_items.delete('21:40')
  end
end
