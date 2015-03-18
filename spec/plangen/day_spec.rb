require 'spec_helper'
require 'plangen/day'

describe Day do
  describe '#workday?' do
    it 'returns true for a week day' do
      expect(Day.new(2015, 3, 16).workday?).to be(true)
    end

    it 'returns false for Saturday' do
      expect(Day.new(2015, 3, 14).workday?).to be(false)
    end

    it 'returns false for Sunday' do
      expect(Day.new(2015, 3, 15).workday?).to be(false)
    end

    it 'returns false for a bank holiday' do
      expect(Day.new(2015, 1, 1).workday?).to be(false)
    end
  end

  describe '#bank_holiday?' do
    it { expect(Day.new(2015, 1, 1).bank_holiday?).to be(true) }
    it { expect(Day.new(2015, 3, 1).bank_holiday?).to be(false) }
  end

  describe '#bank_holiday' do
    it { expect(Day.new(2015, 1, 1).bank_holiday).to eql("New Year's Day") }
  end
end
