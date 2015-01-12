require 'yaml'

MEMOS = YAML.load_file('input.yml')

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
    title 'My Pinboard'
    # pdf.text("Place your post-it notes that might be relevant to today here. Things like shopping lists and such. In general, if you don't know which way are you going to accomplish these and these are not of high priority, just put them on a post-it note and stick them here and move them around as necessary.", style: :italic)
    pdf.move_down 465
    choices = ['Today\'s challenge is', 'Best question I can ask myself today', 'Unpleasant activity']
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
    print_gratitude
    pdf.move_down 10#00 # Make sure this is going to be in the next column.

    title 'Today I Accomplished'
    11.times { line }

    pdf.move_down 5
    line

    pdf.move_down 10
    pdf.text '<i>I performed the habit of this month, properly and mindfully:</i>  [  ] <color rgb="000066">SLT</color>', inline_format: true, size: 11
    pdf.text 'I am currently learning: Spanish'
  end

  def line(options = Hash.new)
    pdf.move_down 5
    pdf.text('_' * 52, options)
    pdf.move_down 5
  end

  # TODO: Different for Sat / refl & Sun.
  def print_schedule
    pdf.text 'Schedule', style: :bold
    pdf.move_down 5
    #pdf.text '<b>6:00 – 6:50</b> Meditation. Set timer to 30 min. Cardio and power-posing. Gratitude. Review the day. Shower. <b>7:00 – 12:30</b> Productivity. <b>12:30 – 13:30</b> Recharge. <b>13:30 – 17:00</b> Less structured afternoon. <b>17:00 – 19:30</b> Dinner. Recharge, reflect & plan. <b>From 19:30 on</b> Keep off the blue light. <b>19:30 – 21:00</b> Clean up. Manual work (HB) & reading. <b>22:30</b> Teeth, meditate & go to sleep.', inline_format: true, style: :italic, size: 11
    # This is so late only so I can adjust to the +8 TZ of SF.
# Every morning my training.
    pdf.text <<-EOF, inline_format: true, style: :italic, size: 11
      <b>9:20 – 9:50</b> Shower. Cardio and power-posing. TED. Gratitude. Review the day.
      <b>10:00 – 11:30</b> 20 miles march.
      <b>11:30 – 12:00</b> Urgencies.
      <b>12:00 – 13:30</b> Lunch & siesta.
      <b>13:30 – 17:30</b> Day job.
      <b>18:00 – 19:00</b> Dinner. Recharge, reflect & plan.
      <b>From 20:00 on</b> Keep off the blue light.
      <b>19:30 – 21:00</b> Clean up. Manual work (HB) & reading.
      <b>23:30</b> Teeth, meditate & go to sleep.
    EOF
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
    pdf.move_down 6
    5.times { line }

    pdf.text 'Affirmations', style: :bold
    pdf.move_down 6
    5.times { line }

    pdf.text 'My Mindset'
    pdf.move_down 6
    pdf.text '[  ] I commit myself to be happy.'
    pdf.text '[  ] I commit myself to let go.'
    pdf.text '[  ] I commit myself to always priorities and use 80/20. I will delegate what I do not have to do personally and I will not do at all what is not important.'
  end

  def print_tasks
    pdf.text 'Today\'s Tasks', style: :bold
    pdf.move_down 5

    pdf.text('20 MM:')
    line(color: 'ff0000')

    pdf.text('Urgencies & Appointments (<i>hopefully empty most of the days</i>):', inline_format: true)
    line
    line

    pdf.text('Day Job:')
    line(color: 'ff0000')
    line

    pdf.text('Evening Activities:')
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
