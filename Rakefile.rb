require "rake"

require "build/monkey"

task :default do
  puts "Starting build monkey..."
  Build::Monkey.start

  puts "Building projects like a monkey..."
  Build::Monkey.new.server  
end