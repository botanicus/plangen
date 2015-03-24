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
    self.tasks.list('20 MM', :twenty_miles_march)
    pdf.text('Urgencies & Appointments (<i>hopefully empty most of the days</i>)', :urgencies_and_appointments)
    (self.tasks.urgencies_and_appointments << nil) << nil
    self.tasks.list('Lunch Break', :lunchbreak)
    self.tasks.list('Evening', :evening)

    if day.tuesday? || day.thursday?
      self.tasks.lunchbreak.push('Go swimming.')
    end

    if self.day.thursday?
      # TODO: Where to put this? schedule? Elsewhere?
      # TODO: Make this_week etc area accessible.
      self.tasks.important.unshift('Fasting.')
      self.tasks.important.push('Relax at the evening. Go to bed early.')
    end
  end
end
