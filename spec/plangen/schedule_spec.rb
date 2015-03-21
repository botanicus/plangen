require 'spec_helper'
require 'plangen/month'
require 'plangen/schedule'

describe Schedule do
  let(:month) { Month.new(2015, 1) }
  let(:day) { Day.new(2015, 1, 1) }

  describe 'schedule registering' do
    it 'pushes a newly inherited schedule class into .schedule' do
      expect {
        Class.new(Schedule)
      }.to change { Schedule.schedules.length }.by(1)
    end

    it 'does not ignore sub-subclasses' do
      expect {
        Class.new(Class.new(Class.new(Schedule)))
      }.to change { Schedule.schedules.length }.by(3)
    end
  end

  describe '.schedule_for_day' do
    context 'empty schedule' do
      it 'raises NoScheduleFoundError if there is no schedule for given day' do
        Schedule.schedules.clear

        expect {
          Schedule.schedule_for_day(month, day)
        }.to raise_error(NoScheduleFoundError)
      end
    end

    it 'raises NoScheduleFoundError if there is no schedule for given day' do
      Schedule.schedules.clear
      Class.new(Schedule) do
        def self.match?(*)
          false
        end
      end

      expect {
        Schedule.schedule_for_day(month, day)
      }.to raise_error(NoScheduleFoundError)
    end

    it 'returns a new instance of schedule class if there is a schedule for given day' do
      Schedule.schedules.clear
      Class.new(Schedule) do
        def self.match?(*)
          true
        end
      end

      schedule = Schedule.schedule_for_day(month, day)
      expect(schedule).to be_kind_of(Schedule.schedules.first)
      expect(schedule.day).to be(day)
    end
  end
end
