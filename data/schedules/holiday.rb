class HolidaySchedule < Schedule
  def self.match?(month, day)
    day.bank_holiday? && ! day.weekend?
  end

  # Instance methods.
  def day_title
    "#{super} #{day.bank_holiday}"
  end

  def day_title_options
    super.merge(color: '330099')
  end
end
