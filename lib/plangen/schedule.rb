require 'yaml'

MEMOS = YAML.load_file('input.yml')

# Refactor: important_tasks, other_tasks

class Schedule
  attr_reader :day, :pdf, :important_tasks, :other_tasks
  def initialize(day, pdf)
    @day, @pdf = day, pdf
    @important_tasks, @other_tasks = Array.new, Array.new

    setup
  end

  # Fasting, reading fasting, shopping fasting etc.
  def generate
    pdf.start_new_page(layout: :portrait)
    generate_conditioning_page

    # pdf.start_new_page(layout: :portrait)
    choices = MEMOS[:random_interactive]
    pdf.move_down 5
    pdf.text choices[rand(choices.length - 1)], style: :italic
    line

    pdf.start_new_page(layout: :portrait)
    generate_productivity_page

    pdf.start_new_page(layout: :portrait)
    generate_reflection_page
  end

  def generate_conditioning_page
    print_header
    pdf.move_down 20

    print_schedule

    pdf.move_down 10
    print_morning_ritual

    pdf.move_down 10
    print_tasks
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
    print_mindset_commitments
    pdf.move_down 10#00 # Make sure this is going to be in the next column.

    title 'Today I Accomplished'
    11.times { line }

    pdf.move_down 5
    line

    pdf.move_down 10

    this_week_habit
    this_week_learning
    this_week_tie_knot
  end

  def this_week_habit
    pdf.text '<i>I performed the habit of this month, properly and mindfully:</i>  [  ] <color rgb="000066">SLT</color>', inline_format: true, size: 11
  end

  def this_week_learning
    MEMOS[:learning].shift if day.monday?

    pdf.text "I am currently learning: #{MEMOS[:learning].first}"
  end

  def this_week_tie_knot
    MEMOS[:tie_knots].shift if day.monday?

    pair = MEMOS[:tie_knots].first
    pdf.text "This week's knot: <a href='#{pair[pair.values.first]}'>#{pair.keys.first}</a>", inline_format: true
  end

  def line(options = Hash.new)
    pdf.move_down 5
    pdf.text('_' * 52, options)
    pdf.move_down 5
  end

  def print_schedule
    pdf.text 'Schedule', style: :bold
    pdf.move_down 5
    schedule_items = MEMOS[:day_schedule][self.class.name]
    raise "No day_schedule for #{self.class.name}" unless schedule_items
    schedule = schedule_items.reduce('') do |buffer, (time, activity)|
      "#{buffer} <b>#{time}</b> #{activity}"
    end

    pdf.text(schedule, inline_format: true, style: :italic, size: 11)
  end

  def print_morning_ritual
    # pdf.text 'Morning Ritual Checklist (6:00)', style: :bold
    # pdf.move_down 5
    # This won't be possible until I have a more sophisticated opportunity clock system in place.
    # pdf.text 'Get up straigh and drink some water. Cardio and power-posing. Gratitude. Review the day. Shower. ~ 40 min', size: 11, style: :italic
    # pdf.text 'Meditation. Set timer to 30 min. Cardio and power-posing. Gratitude. Review the day. Shower.', size: 11, style: :italic
  end

  def print_mindset_commitments
    pdf.text 'My Mindset'
    pdf.move_down 6
    pdf.text '[  ] I commit myself to be happy.'
    pdf.text '[  ] I commit myself to let go.'
    pdf.text '[  ] I commit myself to always priorities and use 80/20. I will delegate what I do not have to do personally and I will not do at all what is not important.'
  end

  def print_tasks
    # Mindfulness notes after each block, rating how it went, immediate reflection.
    pdf.text 'Today\'s Tasks', style: :bold
    pdf.move_down 5

    pdf.text('20 MM:')
    line(color: 'ff0000')

    pdf.text('Urgencies & Appointments (<i>hopefully empty most of the days</i>):', inline_format: true)
    line
    line

    pdf.text('Lunch Time / Evening Activities:')
    important_tasks.each do |task|
      pdf.text(task, size: 11, color: 'ff0000')
    end
    (1 - @important_tasks.length).times { line(color: 'ff0000') }

    other_tasks.each do |task|
      pdf.text(task, size: 11)
    end
    (1 - @other_tasks.length).times { line }
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
