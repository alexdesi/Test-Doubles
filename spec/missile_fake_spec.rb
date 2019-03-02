require 'spec_helper'

class Platform
  def self.launch_missile(missile, code, used_codes)
    case code
    when 'correct'
      if used_codes.contains?(code)
        missile.disable
      else
        used_codes.push_code(code)
        missile.launch
      end
    when 'unsigned', 'expired'
      missile.disable
    end
  end
end

class FakeUsedLaunchCode
  attr_accessor :used_codes

  def initialize
    @used_codes = []
  end

  def contains?(code)
    used_codes.include? code
  end

  def push_code(code)
    used_codes << code
  end
end

describe Platform do
  let(:fake_used_launch_code) { FakeUsedLaunchCode.new }

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

  context 'when launch code is correct' do
    let(:launch_code) { 'correct' }

    it 'does launch missile' do
      Platform.launch_missile(mock_missile, launch_code, fake_used_launch_code)

      expect(mock_missile.launch_was_called).to eq(true)
    end
  end

  context 'when launch code is expired' do
    let(:launch_code) { 'expired' }

    it 'does not launch missile and disables missile' do
      Platform.launch_missile(mock_missile, launch_code, fake_used_launch_code)

      mock_missile.verify_code_red_abort(self)
    end
  end

  context 'when code is unsigned' do
    let(:launch_code) { 'unsigned' }

    it 'does not launch missile and disables missile' do
      Platform.launch_missile(mock_missile, launch_code, fake_used_launch_code)

      mock_missile.verify_code_red_abort(self)
    end
  end

  context 'when code is reused' do
    let(:launch_code) { 'correct' }
    let(:mock_missile_two) { MockMissile.new }
    let(:fake_used_launch_codes) { FakeUsedLaunchCode.new }

    it 'does not launch the missile' do
      Platform.launch_missile(mock_missile, launch_code, fake_used_launch_codes)
      Platform.launch_missile(mock_missile_two, launch_code, fake_used_launch_codes)

      mock_missile_two.verify_code_red_abort(self)
    end
  end
end
