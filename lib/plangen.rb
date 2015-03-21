require 'yaml'
require 'prawn'

require 'plangen/month'
require 'plangen/schedule'

MEMOS = YAML.load_file('data/input.yml')

class MonthScheduleGenerator < Month
  def pdf
    @pdf ||= Prawn::Document.new(
      page_size: 'A5',
      page_layout: :landscape,
      skip_page_creation: true)
  end

  def generate_pdf_document
    self.days.each do |day|
      unless day < Date.today
        schedule = Schedule.schedule_for_day(month, day)
        schedule.generate(pdf)
      end
    end

    # Render the PDF output file.
    puts "~ Generating schedule for #{month}."
    self.pdf.render_file("#{self.name} Schedule.pdf")
  end
end
