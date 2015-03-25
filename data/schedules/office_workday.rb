class OfficeWorkdaySchedule < Schedule
  HEADER_COLOUR = 'ff0000'

  def self.match?(month, day)
    day.workday?
  end

  def schedule_items #####
    puts 'REDEF schedule'
    super
  end

  def setup
    # TODO: Make the schedule accessible.
    self.tasks.list('20 MM', :twenty_miles_march, 1)
    # self.tasks.list('Urgencies & Appointments (<i>hopefully empty most of the days</i>)', :urgencies_and_appointments)
    self.tasks.list('Lunch Break', :lunchbreak, 3)
    self.tasks.list('Evening', :evening, 3)

    if day.tuesday? || day.thursday?
      self.tasks.lunchbreak.push('Go swimming.')
    end

    if self.day.thursday?
      # TODO: Where to put this? schedule? Elsewhere?
      # TODO: Make this_week etc area accessible.
      self.tasks.lunchbreak.unshift('Fasting.')
      self.tasks.evening.push('Relax at the evening. Go to bed early.')
    end
  end
end
