require 'plangen/tasklist'

class NoScheduleFoundError < StandardError
  def initialize(day)
    super("No schedule found for #{day}.")
  end
end

module PDFFormattingMixin
  def subtitle(pdf, text)
    pdf.move_down 10
    pdf.text(text, style: :italic, size: 11)
    # pdf.move_down 5
  end

  def title(pdf, text)
    pdf.text(text, style: :bold)
  end

  def line(pdf, options = Hash.new)
    pdf.move_down 5
    pdf.text('_' * 52, options)
    pdf.move_down 5
  end
end

class Schedule
  include PDFFormattingMixin

  @@schedules = Array.new
  def self.schedules
    @@schedules
  end

  def self.inherited(subclass)
    @@schedules << subclass
  end

  # @api private
  def self.schedule_class_for_day(month, day)
    self.schedules.reverse.find do |schedule|
      schedule.match?(month, day)
    end
  end

  def self.schedule_for_day(month, day)
    schedule_class = self.schedule_class_for_day(month, day)
    raise NoScheduleFoundError.new(day) if schedule_class.nil?
    schedule_class.new(day)
  end

  def self.match?(month, day)
    raise NotImplementedError.new("Redefine #{self}.match?")
  end

  attr_reader :day, :tasks
  def initialize(day)
    @day, @tasks = day, TaskList.new
  end

  # @api public
  def setup
  end

  def generate(pdf)
    pdf.start_new_page(layout: :portrait)
    print_first_page(pdf)

    pdf.start_new_page(layout: :portrait)
    print_second_page(pdf)

    pdf.start_new_page(layout: :portrait)
    print_third_page(pdf)

    pdf.start_new_page(layout: :portrait)
    print_fourth_page(pdf)
  end

  # Page 1 - tasks.
  def print_first_page(pdf)
    print_header(pdf)
    pdf.move_down 20
    print_schedule(pdf)

    pdf.move_down 10
    # print_morning_ritual # Deprecated in favour of 5MJ

    pdf.move_down 10
    print_tasks(pdf)
    print_random_activity(pdf)
  end

  # Header.
  def print_header(pdf)
    pdf.text day.strftime("%A %-d/%-m/%Y #{day.bank_holiday if day.bank_holiday?}"), style: :bold, color: self.class::HEADER_COLOUR, align: :center, size: 14
    pdf.move_down 10
    memo = MEMOS[:productivity].sample
    pdf.text memo, style: :italic, size: 11, align: :center
  end

  def schedule_items
    MEMOS[:day_schedule][self.class.name]
  end

  def print_schedule(pdf)
    pdf.text 'Schedule', style: :bold
    pdf.move_down 5
    raise "No day_schedule for #{self.class.name}" unless schedule_items
    schedule = schedule_items.reduce('') do |buffer, (time, activity)|
      # Schedule items can be either a hash or an array.
      activity = time if activity.nil?
      "#{buffer} <b>#{time}</b> #{activity}"
    end

    pdf.text(schedule, inline_format: true, style: :italic, size: 11)
  end

  def print_tasks(pdf)
    pdf.text 'Today\'s Tasks', style: :bold
    pdf.move_down 5

    self.tasks.each do |label, items|
      pdf.text(label)
      items.each do |item|
        pdf.text(item || line(pdf))
      end
    end
  end

  def random_interactive
    MEMOS[:random_interactive].sample
  end

  def print_random_activity(pdf)
    pdf.move_down 5
    pdf.text(self.random_interactive, style: :italic)
    line(pdf)
  end

  # Page 2 - mindset.
  def print_second_page(pdf)
    print_mindset_commitments(pdf)
    pdf.move_down 10#00 # Make sure this is going to be in the next column.

    title pdf, 'Today I Accomplished'
    11.times { line(pdf) }

    pdf.move_down 5
    line(pdf)

    pdf.move_down 10

    this_week_habit(pdf)
    this_week_learning(pdf)
    this_week_tie_knot(pdf)
  end

  def mindset_commitments
    MEMOS[:mindset_commitments]
  end

  def print_mindset_commitments(pdf)
    pdf.text 'My Mindset'
    pdf.move_down 6
    self.mindset_commitments.each do |commitment|
      pdf.text(commitment)
    end
  end

  def this_week_habit(pdf)
    pdf.text '<i>I performed the habit of this month, properly and mindfully:</i>  [  ] <color rgb="000066">SLT</color>', inline_format: true, size: 11
  end

  def this_week_learning(pdf)
    MEMOS[:learning].shift if day.monday?

    pdf.text "I am currently learning: #{MEMOS[:learning].first}"
  end

  # Fasting, reading fasting, shopping fasting etc.
  def this_week_tie_knot(pdf)
    MEMOS[:tie_knots].shift if day.monday?

    pair = MEMOS[:tie_knots].first
    pdf.text "This week's knot: <a href='#{pair[pair.values.first]}'>#{pair.keys.first}</a>", inline_format: true
  end

  # Page 3 - ????.
  def print_third_page(pdf)
  end

  # Page 4 – reflection.
  def print_fourth_page(pdf)
    title pdf, 'Reflection'
    subtitle pdf, 'What went well'
    5.times { line(pdf) }
    subtitle pdf, 'Opportunities for improvement'
    5.times { line(pdf) }
    subtitle pdf, 'What I have  learnt'
    7.times { line(pdf) }
  end
end
