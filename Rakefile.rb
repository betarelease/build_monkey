require "rake"

require "build/process_god"
require "build/monkey"

task :default do
  Build::Monkey.start
  puts "Started build server ..."
  BUILD_COMMAND = "custom_build.sh"
  RESULT_FILE = "custom_result.txt"

  puts "Building projects like a monkey..."
  Build::Monkey.instance.schedule( "projects" )

  Build::Monkey.instance.server
end
