require "rake"

require "./build/process_god"
require "./build/monkey"

require 'spec/rake/spectask'
PROJECT_PATH = File.expand_path( File.dirname(__FILE__) )

desc "starts a build monkey server"
task :default do
  build_monkey = Build::Monkey.instance
  build_monkey.server
  puts "Started build server ..."
  BUILD_COMMAND = "custom_build.sh"
  RESULT_FILE = "custom_result.txt"

  puts "Building projects like a monkey..."
  build_monkey.schedule( "projects" )

  build_monkey.run
end

desc "Run all specs in spec directory"
SPEC_DIR = "#{PROJECT_PATH}/spec"
Spec::Rake::SpecTask.new do |task|
  task.spec_opts = ['--options', "#{SPEC_DIR}/spec.opts"]
  task.pattern   = "spec/**/*_spec.rb"
  
  # task.spec_files = FileList['spec/**/*_spec.rb']
end

