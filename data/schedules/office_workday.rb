class OfficeWorkdaySchedule < Schedule
  HEADER_COLOUR = 'ff0000'

  def setup
    if day.tuesday? || day.thursday?
      important_tasks.push('Go swimming.')
    end
  end
end
