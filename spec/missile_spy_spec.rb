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
  class SpyMissile
    attr_reader :launch_was_called, :disable_was_called
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
  end

  def verify_code_red_abort(spy_missile)
    expect(spy_missile.launch_was_called).to eq(false)
    expect(spy_missile.disable_was_called).to eq(true)
  end

  let(:spy_missile) { SpyMissile.new }

  context 'when launch code is not expired' do
    let(:launch_code) { 'correct' }

    it 'does launch missile' do
      Platform.launch_missile(spy_missile, launch_code)

      expect(spy_missile.launch_was_called).to eq(true)
    end
  end

  context 'when launch code is expired' do
    let(:launch_code) { 'expired' }

    it 'does not launch missile and disables missile' do
      Platform.launch_missile(spy_missile, launch_code)

      verify_code_red_abort(spy_missile)
    end
  end

  context 'when code is unsigned' do
    let(:launch_code) { 'unsigned' }

    it 'does not launch missile and disables missile' do
      Platform.launch_missile(spy_missile, launch_code)

      verify_code_red_abort(spy_missile)
    end
  end
end
