class HolidaySchedule < Schedule
  HEADER_COLOUR = '330099'

  def self.match?(month, day)
    day.bank_holiday? && ! day.weekend?
  end
end
