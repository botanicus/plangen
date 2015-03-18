require 'date'
require 'holidays'

class Day < Date
  def workday?
    ! (self.saturday? || self.sunday? || self.bank_holiday?)
  end

  def bank_holiday?
    holiday?(COUNTRY, :observed)
  end

  def bank_holiday
    if bank_holiday?
      holidays(COUNTRY, :observed).map { |holiday| holiday[:name] }.join(' and ')
    end
  end
end
