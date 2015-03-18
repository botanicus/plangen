require 'spec_helper'
require 'plangen/month'

describe Month do
  subject { described_class.new(2015, 3) }

  describe '#year' do
    it { expect(subject.year).to eql(2015) }
  end

  describe '#month' do
    it { expect(subject.month).to eql(3) }
  end

  describe '#name' do
    it { expect(subject.name).to eql('March') }
  end

  describe '#days' do
    it { expect(subject.days.length).to eql(31) }
    it { expect(subject.days.first).to be_kind_of(Day) }
  end

  describe '#workdays' do
    it do
      workdays = subject.workdays.map(&:to_s)
      expect(workdays).to eql([
        '2015-03-02', '2015-03-03', '2015-03-04', '2015-03-05', '2015-03-06',
        '2015-03-09', '2015-03-10', '2015-03-11', '2015-03-12', '2015-03-13',
        '2015-03-16', '2015-03-17', '2015-03-18', '2015-03-19', '2015-03-20',
        '2015-03-23', '2015-03-24', '2015-03-25', '2015-03-26', '2015-03-27',
        '2015-03-30'])
    end

    context 'bank holidays' do
      it 'does not include any'
    end

    context 'reflection day' do
      it { expect(subject.workdays.map(&:to_s)).not_to include('2015-03-31') }
    end
  end
end
