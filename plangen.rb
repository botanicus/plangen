#!/usr/bin/env ruby

# == Usage == #
# ./plangen.rb         # Defaults to the current month.
# ./plangen.rb 2015/4  # April 2015.

$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'plangen'

# Configuration.
COUNTRY = :gb

# Start day.
if date = ARGV.shift
  year, month = date.split('/').map(&:to_i)
else
  year, month = Time.now.year, Time.now.month
end

# Load user-specific schedules.
Dir.glob('data/schedules/*.rb').each do |path|
  load path
end

# Generate the PDF for given month.
schedule_generator = MonthScheduleGenerator.new(year, month)
schedule_generator.generate_pdf_document
