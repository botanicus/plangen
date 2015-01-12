class ReflectionDaySchedule < Schedule
  HEADER_COLOUR = '336633'
  # is a relaxation, reflection, planning & journalling day (#{current_day.sunday? ? 'Sunday' : 'monthly catch-up'}).
  # Vykartacovat klobouky, boty.
  # Coursera
  # review plangen or other self-programming, work on my ebook. Go through all the notes from this week.

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
