class NoScheduleFoundError < StandardError
  def initialize(day)
    super("No schedule found for #{day}.")
  end
end

class ConfigurationMissingError < StandardError
  def initialize
    super("Configuration file data/input.yml hasn't been found.")
  end
end
