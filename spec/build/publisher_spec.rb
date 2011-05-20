require 'spec_helper'

describe Build::Publisher do

  it "sanitizes jobs list" do
    publisher = Build::Publisher.new(".")
    sanitized_jobs = Dir.entries(".").reject { |job| job == "." || job == ".." }
    sanitized_jobs.should == publisher.sanitize
  end
  
end