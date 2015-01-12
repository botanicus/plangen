require 'date'
require 'holidays'

require_relative 'plangen/schedule'
require_relative 'plangen/schedules/office_workday'
require_relative 'plangen/schedules/saturday_and_holidays'
require_relative 'plangen/schedules/reflection_day'

class Day < Date
  def workdays_of_the_month
    workdays = Array.new
    current_day = Day.new(year, month, 1)

    while month == current_day.month
      if current_day.would_be_office_workday?
        workdays << current_day
      end
      current_day += 1
    end

    workdays
  end


  def would_be_office_workday?
    ! (saturday? || sunday? || bank_holiday?)
  end

  def office_workday?
    would_be_office_workday? && ! reflection_day?
  end

  def bank_holiday
    if bank_holiday?
      holidays(:us, :observed).map { |holiday| holiday[:name] }.join(' and ')
    end
  end

  def bank_holiday?
    holiday?(:us, :observed)
  end

  def startup_workday?
    (saturday? || bank_holiday?) && ! reflection_day?
  end

  # Last 2 work days of the month.
  def reflection_day?
    sunday? || (workdays_of_the_month.reverse.index(self) && workdays_of_the_month.reverse.index(self) <= 1)
  end

  def schedule(pdf)
    if office_workday?
      OfficeWorkdaySchedule.new(self, pdf)
    elsif startup_workday?
      SaturdayAndHolidaysSchedule.new(self, pdf)
    elsif reflection_day?
      ReflectionDaySchedule.new(self, pdf)
    end
  end
end
