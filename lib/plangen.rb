require 'yaml'
require 'prawn'

require 'plangen/month'
require 'plangen/schedule'

# TODO: This probably shouldn't inherit from
# Month, but rather just instantiate it.
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
        schedule = Schedule.schedule_for_day(self, day)
        schedule.setup
        schedule.generate(pdf)
      end
    end

    # Render the PDF output file.
    puts "~ Generating schedule for #{self}."
    self.pdf.render_file("#{self.name} Schedule.pdf")
  end
end
