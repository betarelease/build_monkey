require 'spec_helper'
require 'build/monkey'

describe Build::Monkey do

  it "sanitizes jobs list" do
    monkey = Build::Monkey.new
    sanitized_jobs = Dir.entries(".").reject { |job| job == "." || job == ".." }
    sanitized_jobs.should == monkey.sanitize( "." )
  end
end