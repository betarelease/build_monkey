require "rake"

require "build/process_god"
require "build/monkey"

task :default do
  Build::Monkey.start
  puts "Started build server ..."

  puts "Building projects like a monkey..."
  Build::Monkey.new.schedule( "projects" )

  Build::Monkey.new.server
end