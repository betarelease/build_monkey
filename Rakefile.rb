require "rake"

require 'spec/rake/spectask'

ENV["ENVIRONMENT"] = "test"

require File.expand_path( File.join( File.dirname( __FILE__ ), 'config', 'boot' ) )

desc "default task: runs all specs and prints usage message"
task :default => [:spec] do
  puts " Usage of build_monkey...."
  puts "     rake build "
  puts "          looks in the projects folder and runs build commands for each project"
  puts " ------------------------------ Simple and Easy ------------------------------"
end

desc "starts a build monkey server"
task :build do
  build_monkey = Build::Monkey.instance
  build_monkey.server
  puts "Started build server ..."
  BUILD_COMMAND = "custom_build.sh"
  RESULT_FILE = "custom_result.txt"

  puts "Building projects like a monkey..."
  build_monkey.schedule( "projects" )

  build_monkey.run
end

SPEC_DIR = "#{PROJECT_PATH}/spec"

desc "Run all specs in spec directory"
Spec::Rake::SpecTask.new do |task|
  task.spec_opts = ['--options', "#{SPEC_DIR}/spec.opts"]
  task.pattern   = "spec/**/*_spec.rb"  
end

