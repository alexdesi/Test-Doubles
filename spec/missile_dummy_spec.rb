require 'spec_helper'

class Platform
  def self.launch_missile(missile, code)
    if code
      missile.launch
      true
    end

    false
  end
end

describe Platform do
  class DummyMissile
    def launch
      raise 'BOOM!'
    end
  end

  it 'does not launch missile when launch code is expired' do
    dummy_missile = DummyMissile.new
    launch_code = false

    expect(Platform.launch_missile(dummy_missile, launch_code)).to eq(false)
  end

end
