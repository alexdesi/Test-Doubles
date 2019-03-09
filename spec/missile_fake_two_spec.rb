require 'spec_helper'

class Platform
  def self.launch_missile(missile, code, used_launch_codes)
    if used_launch_codes.invalid?(code)
      missile.disable
    else
      missile.launch
      used_launch_codes.invalidate_code(code)
    end
  end
end

describe Platform do
  class SpyMissile
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

  class UsedLaunchCodeFake
    def initialize
      @used_codes = []
    end

    def invalidate_code(code)
      @used_codes << code
    end

    def invalid?(code)
      @used_codes.include?(code) || code == 'unsigned' || code == 'expired'
    end
  end

  def verify_code_red_abort(spy_missile)
    expect(spy_missile.launch_was_called).to eq(false)
    expect(spy_missile.disable_was_called).to eq(true)
  end

  let(:spy_missile) { SpyMissile.new }

  context 'when launch code is not expired' do
    let(:launch_code) { '111' }

    it 'does launch missile' do
      Platform.launch_missile(spy_missile, launch_code, UsedLaunchCodeFake.new)

      expect(spy_missile.launch_was_called).to eq(true)
    end
  end

  context 'when launch code is expired' do
    let(:launch_code) { 'expired' }

    it 'does not launch missile and disables missile' do
      Platform.launch_missile(spy_missile, launch_code, UsedLaunchCodeFake.new)

      verify_code_red_abort(spy_missile)
    end
  end

  context 'when code is unsigned' do
    let(:launch_code) { 'unsigned' }

    it 'does not launch missile and disables missile' do
      Platform.launch_missile(spy_missile, launch_code, UsedLaunchCodeFake.new)

      verify_code_red_abort(spy_missile)
    end
  end

  context 'when code was used' do
    let(:launch_code) { 'correct' }

    it 'triggers code red abort' do
      spy_missile_two = SpyMissile.new
      used_launch_codes = UsedLaunchCodeFake.new

      Platform.launch_missile(spy_missile, launch_code, used_launch_codes)
      Platform.launch_missile(spy_missile_two, launch_code, used_launch_codes)

      verify_code_red_abort(spy_missile_two)
    end
  end

  context 'when two correct codes are used' do
    it 'launches two different missiles' do
      spy_missile_two = SpyMissile.new
      used_launch_codes = UsedLaunchCodeFake.new
      launch_code_one = '111'
      launch_code_two = '333'

      Platform.launch_missile(spy_missile, launch_code_one, used_launch_codes)
      expect(spy_missile.launch_was_called).to eq(true)

      Platform.launch_missile(spy_missile_two, launch_code_two, used_launch_codes)
      expect(spy_missile_two.launch_was_called).to eq(true)
    end
  end
end
