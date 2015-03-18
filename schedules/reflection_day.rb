# is a relaxation, reflection, planning & journalling day
# Vykartacovat klobouky, boty.
# Review plangen or other self-programming, work on my ebook.

class SundaySchedule < Schedule
  HEADER_COLOUR = '336633'

  def setup
  end

  def print_tasks
    pdf.text 'Today\'s Tasks', style: :bold
    pdf.move_down 5

    important_tasks.each do |task|
      pdf.text(task, size: 11, color: 'ff0000')
    end
    (1 - @important_tasks.length).times { line(color: 'ff0000') }

    other_tasks.each do |task|
      pdf.text(task, size: 11)
    end
    (1 - @other_tasks.length).times { line }
  end
end

class MonthReflectionDaySchedule < SundaySchedule
end
