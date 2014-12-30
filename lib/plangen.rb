require 'date'
require 'yaml'
require 'holidays'

MEMOS = YAML.load_file('memos.yml')

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
    Schedule.new(self, pdf)
    if office_workday?
      OfficeWorkdaySchedule.new(self, pdf)
    elsif startup_workday?
      StartupWorkdaySchedule.new(self, pdf)
    elsif reflection_day?
      ReflectionDaySchedule.new(self, pdf)
    end
  end
end

class Schedule
  attr_reader :day, :pdf
  def initialize(day, pdf)
    @day, @pdf = day, pdf
  end

  def generate
    pdf.start_new_page

    pdf_header
    pdf.move_down 20

    pdf.column_box([0, pdf.cursor], columns: 2, width: pdf.bounds.width) do
      pdf_morning_ritual

      pdf.move_down 10
      pdf_gratitude

      pdf.move_down 10
      pdf_tasks

      pdf.move_down 1000 # Make sure this is going to be in the next column.
      pdf_presleep_ritual

      pdf.move_down 10
      pdf_reflection
    end
  end

  def pdf_morning_ritual
    pdf.text 'Morning Ritual Checklist (~ 7 AM)', style: :bold, size: 11
    pdf.move_down 5
    pdf.text 'Get up straigh and drink some water. Cardio and power-posing. Gratitude. Review the day. Shower. ~ 40 min', size: 10, style: :italic
  end

  def pdf_gratitude
    pdf.text 'Gratitude', style: :bold, size: 11
    pdf.move_down 5
    3.times { pdf.text '_____________________________________________', size: 10 }
  end

  def pdf_tasks
    pdf.text 'Today\'s Tasks', style: :bold, size: 11
    pdf.move_down 5
    2.times { pdf.text '_____________________________________________', size: 10, color: 'ff0000' }
    3.times { pdf.text '_____________________________________________', size: 10 }
    pdf.move_down 10
    pdf.text 'Today\'s challenge is: ____________________________', size: 10
  end

  def pick_memo
    MEMOS[rand(MEMOS.length - 1)]
  end

  def pdf_header
    pdf.text day.strftime("%A %-d/%-m/%Y #{day.bank_holiday if day.bank_holiday?}"), style: :bold, color: self.class::HEADER_COLOUR, align: :center, size: 14
    # TODO: Colour based on type of the day.
    pdf.move_down 10
    pdf.text pick_memo, style: :italic, size: 11, align: :center
  end

  def pdf_presleep_ritual
    pdf.text 'Pre-Sleep Ritual Checklist (22:00)', style: :bold, size: 11
    pdf.move_down 5
    pdf.text 'Keep off blue light. Plan the next day. Read until 23:20. Then meditate and sleep.', style: :italic, size: 10
  end

  def pdf_reflection
    pdf.text 'Reflection', style: :bold, size: 11
    pdf.move_down 5
    pdf.text 'What went well:  _______________________________', style: :italic, size: 10
    3.times { pdf.text '_____________________________________________', size: 10 }
    pdf.move_down 10
    pdf.text 'Opportunities for improvement:  ___________________', style: :italic, size: 10
    3.times { pdf.text '_____________________________________________', size: 10 }
  end
end

class OfficeWorkdaySchedule < Schedule
  HEADER_COLOUR = 'ff0000'
end

class StartupWorkdaySchedule < Schedule
  HEADER_COLOUR = '330099'
  # 3+2 work / mine in office workday (se schuzkama & urgent list)
end

class ReflectionDaySchedule < Schedule
  HEADER_COLOUR = '336633'
  # is a relaxation, reflection, planning & journalling day (#{current_day.sunday? ? 'Sunday' : 'monthly catch-up'}).
end
