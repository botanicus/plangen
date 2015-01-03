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
  attr_reader :day, :pdf, :important_tasks, :other_tasks
  def initialize(day, pdf)
    @day, @pdf = day, pdf
    @important_tasks, @other_tasks = Array.new, Array.new

    setup
  end

  def generate
    pdf.start_new_page(layout: :portrait)
    generate_conditioning_page

    pdf.start_new_page(layout: :portrait)
    generate_productivity_page

    pdf.start_new_page(layout: :portrait)
    generate_reflection_page

    pdf.start_new_page(layout: :portrait)
    title 'Notes'
    20.times { line }
  end

  def generate_conditioning_page
    print_header
    pdf.move_down 20

    print_schedule

    pdf.move_down 10
    print_morning_ritual

    pdf.move_down 10
    print_tasks

    pdf.move_down 10#00 # Make sure this is going to be in the next column.
    print_gratitude

    pdf.move_down 10
    choices = ['Today\'s challenge is', 'Best question I can ask myself today', 'Unpleasant activity']
    pdf.text choices[rand(choices.length - 1)], style: :italic
    pdf.move_down 5
    line

    pdf.move_down 10
    pdf.text '<i>This month\'s habit is:</i>  [  ] <color rgb="000066">SLT</color>', inline_format: true, size: 11
  end

  def subtitle(text)
    pdf.move_down 10
    pdf.text(text, style: :italic, size: 11)
    # pdf.move_down 5
  end

  def title(text)
    pdf.text(text, style: :bold)
  end

  def generate_productivity_page
    title 'Pomodoros'
    subtitle '20 Miles March. Main goal is _________________________________'
    3.times { line }
    subtitle 'Job Productivity. Main goal is _________________________________'
    3.times { line }
    subtitle 'Maintenance. Main goal is ___________________________________'
    3.times { line }
    pdf.move_down 10
    title 'Errands'
    8.times { line }
  end

  def line(options = Hash.new)
    pdf.move_down 5
    pdf.text('_' * 52, options)
    pdf.move_down 5
  end

  def print_schedule
    pdf.text 'Schedule', style: :bold
    pdf.move_down 5
    pdf.text '<b>6:00 – 6:50</b> Meditation. Set timer to 30 min. Cardio and power-posing. Gratitude. Review the day. Shower. <b>7:00 – 12:30</b> Productivity. <b>12:30 – 13:30</b> Recharge. <b>13:30 – 17:00</b> Less structured afternoon. <b>17:00 – 19:30</b> Dinner. Recharge, reflect & plan. <b>From 19:30 on</b> Keep off the blue light. <b>19:30 – 21:00</b> Clean up. Manual work (HB) & reading. <b>22:30</b> Teeth, meditate & go to sleep.', inline_format: true, style: :italic, size: 11

    # pdf.text '<b>6:00 – 6:50</b> Morning ritual.', size: 11, color: '336633', inline_format: true
    # pdf.text '<b>7:00 – 12:30</b> Productivity.', size: 11, color: 'ff0000', inline_format: true
    # pdf.text '<b>12:30 – 13:30</b> Recharge.', size: 11, color: '336633', inline_format: true
    # pdf.text '<b>13:30 – 17:00</b> Less structured afternoon.', size: 11, color: 'ff0000', inline_format: true
    # pdf.text '<b>17:00 – 19:30</b> Dinner. Recharge, reflect & plan.', size: 11, color: '336633', inline_format: true
    # pdf.text '<b>From 19:30 on</b> Keep off the blue light.', size: 11, color: '336633', inline_format: true
    # pdf.text '<b>19:30 – 21:00</b> Clean up. Manual work (HB) & reading.', size: 11, color: '336633', inline_format: true
    # pdf.text '<b>22:30</b> Teeth, meditate & go to sleep.', size: 11, color: '336633', inline_format: true
  end

  def print_morning_ritual
    # pdf.text 'Morning Ritual Checklist (6:00)', style: :bold
    # pdf.move_down 5
    # This won't be possible until I have a more sophisticated opportunity clock system in place.
    # pdf.text 'Get up straigh and drink some water. Cardio and power-posing. Gratitude. Review the day. Shower. ~ 40 min', size: 11, style: :italic
    # pdf.text 'Meditation. Set timer to 30 min. Cardio and power-posing. Gratitude. Review the day. Shower.', size: 11, style: :italic
  end

  def print_gratitude
    pdf.text 'Gratitude', style: :bold
    pdf.move_down 5
    3.times { line }
  end

  def print_tasks
    pdf.text 'Today\'s Tasks', style: :bold
    pdf.move_down 5

    important_tasks.each do |task|
      pdf.text(task, size: 11, color: 'ff0000')
    end
    (2 - @important_tasks.length).times { line(color: 'ff0000') }

    other_tasks.each do |task|
      pdf.text(task, size: 11)
    end
    (3 - @other_tasks.length).times { line }
  end

  def pick_memo(kind = :productivity)
    MEMOS[kind][rand(MEMOS.length - 1)]
  end

  def print_header
    pdf.text day.strftime("%A %-d/%-m/%Y #{day.bank_holiday if day.bank_holiday?}"), style: :bold, color: self.class::HEADER_COLOUR, align: :center, size: 14
    pdf.move_down 10
    pdf.text pick_memo, style: :italic, size: 11, align: :center
  end

  def generate_reflection_page
    title 'Reflection'
    subtitle 'What went well'
    5.times { line }
    subtitle 'Opportunities for improvement'
    5.times { line }
    subtitle 'What I have  learnt'
    7.times { line }
  end
end

class OfficeWorkdaySchedule < Schedule
  HEADER_COLOUR = 'ff0000'

  def setup
    important_tasks.push('Go swimming.') if day.wednesday?
  end
end

class StartupWorkdaySchedule < Schedule
  HEADER_COLOUR = '330099'
  # 3+2 work / mine in office workday (se schuzkama & urgent list)

  def setup
  end

  def generate_afternoon_page
    # HB instead of cleanup
  end
end

class ReflectionDaySchedule < Schedule
  HEADER_COLOUR = '336633'
  # is a relaxation, reflection, planning & journalling day (#{current_day.sunday? ? 'Sunday' : 'monthly catch-up'}).

  def setup
  end
end
