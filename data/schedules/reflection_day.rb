class SundaySchedule < Schedule
  HEADER_COLOUR = '336633'

  def self.match?(month, day)
    day.sunday?
  end

  def setup
    self.tasks.list('Important', :important)
    self.tasks.list('Errands', :errands)
  end

  def print_tasks(pdf)
    pdf.text 'Today\'s Tasks', style: :bold
    pdf.move_down 5

    self.tasks.important.each do |task|
      pdf.text(task, size: 11, color: 'ff0000')
    end
    (1 - self.tasks.important.length).times { line(pdf, color: 'ff0000') }

    self.tasks.errands.each do |task|
      pdf.text(task, size: 11)
    end
    (1 - self.tasks.errands.length).times { line(pdf) }
  end
end

class MonthReflectionDaySchedule < SundaySchedule
  # TODO: Collision with Saturdays and Sundays.
  # Currently firstly registered will have priority.
  def self.match?(month, day)
    month.days.last == day
  end
end
