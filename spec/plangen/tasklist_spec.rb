require 'spec_helper'
require 'plangen/month'
require 'plangen/schedule'

describe TaskList do
  describe '#list' do
    it 'enables you to register new lists' do
      subject.list('Morning', :morning)
      subject.morning.push('Go jogging.')
      subject.morning.push('Go to work.')
      subject.list('Lunch break', :lunchbreak, 3)
      subject.lunchbreak.push('Go swimming.')
      subject.list('Evening', :evening, 0)

      # This tests #each as well.
      items = subject.each.to_a
      expect(items[0][0]).to eq('Morning')
      expect(items[0][1]).to eq(['Go jogging.', 'Go to work.'])

      expect(items[1][0]).to eq('Lunch break')
      expect(items[1][1]).to eq(['Go swimming.', nil, nil])

      expect(items[2][0]).to eq('Evening')
      expect(items[2][1]).to eq([])
    end
  end
end
