require 'spec_helper'

describe Build::Publisher do

  it "sanitizes jobs list" do
    publisher = Build::Publisher.new("projects")
    sanitized_jobs = Dir.entries("projects").reject { |job| job == "." || job == ".." }
    sanitized_jobs.should == publisher.sanitized_jobs
  end
  
  it "publishes job to given tuplespace" do
    project_root = "projects"
    publisher = Build::Publisher.new(project_root)
    tuplespace = mock("tuplespace") 
    publisher.sanitized_jobs.each do |job|
      tuplespace.should_receive(:write).with([:project, "#{project_root}/#{job}"])
    end
    publisher.publish(tuplespace)
  end
  
end