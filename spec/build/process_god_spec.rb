require 'spec_helper'
require 'build/process_god'

describe Build::ProcessGod do

  it "can spawn and kill processes" do
    Build::ProcessGod.spawn
    Process.should_receive( :kill )
    Build::ProcessGod.reap
  end
  
end