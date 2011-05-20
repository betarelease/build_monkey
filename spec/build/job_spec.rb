require 'spec_helper'

describe Build::Job do

  it "finds job to run" do
    job = Build::Job.new("projects/p1")
    found_job = Dir.entries("projects/p1").reject { |job| job == "." || job == ".." }
    found_job.first.should == job.find.first
  end
end