require "rake"

require "build/process_god"
require "build/monkey"

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

desc "run all specs"
task :spec
