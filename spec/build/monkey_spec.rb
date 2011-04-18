require 'spec_helper'
require 'build/monkey'

describe Build::Monkey do

  it "sanitizes jobs list" do
    monkey = Build::Monkey.instance
    sanitized_jobs = Dir.entries(".").reject { |job| job == "." || job == ".." }
    sanitized_jobs.should == monkey.sanitize( "." )
  end
  
  it "finds job to run" do
    monkey = Build::Monkey.instance
    found_job = Dir.entries("projects/p1").reject { |job| job == "." || job == ".." }
    found_job.should == monkey.find_job("projects/p1")
  end
end