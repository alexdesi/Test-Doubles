require 'spec_helper'

class Platform
  def self.launch_missile(missile, code)
    case code
    when 'correct'
      missile.launch
      true
    when 'unsigned', 'expired'
      missile.disable
      false
    end
  end
end

describe Platform do
  class MockMissile
    attr_reader :launch_was_called, :disable_was_called

    def initialize
      @launch_was_called = false
      @disable_was_called = false
    end

    def launch
      @launch_was_called = true
    end

    def disable
      @disable_was_called = true
    end

    def verify_code_red_abort(test)
      test.expect(launch_was_called).to test.eq(false)
      test.expect(disable_was_called).to test.eq(true)
    end
  end

  let(:mock_missile) { MockMissile.new }

  context 'when launch code is not expired' do
    let(:launch_code) { 'correct' }

    it 'does launch missile' do
      Platform.launch_missile(mock_missile, launch_code)

      expect(mock_missile.launch_was_called).to eq(true)
    end
  end

  context 'when launch code is expired' do
    let(:launch_code) { 'expired' }

    it 'does not launch missile and disables missile' do
      Platform.launch_missile(mock_missile, launch_code)

      mock_missile.verify_code_red_abort(self)
    end
  end

  context 'when code is unsigned' do
    let(:launch_code) { 'unsigned' }

    it 'does not launch missile and disables missile' do
      Platform.launch_missile(mock_missile, launch_code)

      mock_missile.verify_code_red_abort(self)
    end
  end
end
