class OfficeWorkdaySchedule < Schedule
  HEADER_COLOUR = 'ff0000'

  def self.match?(month, day)
    day.workday?
  end

  def setup
    if day.tuesday? || day.thursday?
      self.tasks.important.push('Go swimming.')
    end

    if self.day.thursday?
      self.tasks.important.unshift('Fasting.')
      self.tasks.important.push('Relax at the evening. Go to bed early.')
    end
  end
end
