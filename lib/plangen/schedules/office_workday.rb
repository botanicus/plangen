class OfficeWorkdaySchedule < Schedule
  HEADER_COLOUR = 'ff0000'

  def setup
    important_tasks.push('Go swimming.') if day.wednesday?
  end
end
