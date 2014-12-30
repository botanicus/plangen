#!/usr/bin/env ruby

require 'prawn'
require_relative 'lib/plangen.rb'

# Start day.
start_day = current_day = Day.new(2015, 1, 1)

# PDF document settings.
pdf = Prawn::Document.new(
  page_size: 'A5',
  page_layout: :landscape,
  skip_page_creation: true)

# Add schedule for all the days of the month to the PDF document.
while start_day.month == current_day.month
  current_day.schedule(pdf).generate
  current_day += 1
end

# Render the PDF output file.
pdf.render_file(start_day.strftime('%B Schedule.pdf'))
