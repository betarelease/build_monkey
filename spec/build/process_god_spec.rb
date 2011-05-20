require 'spec_helper'

describe Build::ProcessGod do

  xit "can spawn and kill processes" do
    Build::ProcessGod.spawn
    Process.should_receive( :kill )
    Build::ProcessGod.reap
  end
  
end