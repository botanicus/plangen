require 'plangen/day'

class Month
  attr_reader :year, :month
  def initialize(year, month)
    @year, @month = year, month
    @start_day = Day.new(year, month, 1)
  end

  def name
    Day::MONTHNAMES[@start_day.month]
  end

  def days
    days, day_index = [], 1
    loop do
      days << Day.new(self.year, self.month, day_index)
      day_index += 1
    end
  rescue ArgumentError # Invalid date.
    return days
  end

  def workdays
    days_minus_reflection_day = self.days[0..-2]
    days_minus_reflection_day.select(&:workday?)
  end

  def inspect
    "#<#{self.class} #{@start_day.strftime('%Y/%m')}>"
  end
end
