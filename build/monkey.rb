require 'drb/drb'
require 'rinda/rinda' 
require 'rinda/tuplespace'

module Build
  class Monkey

    PROJECT_ROOT = "./projects"
    projects = [ "#{PROJECT_ROOT}/p1", "#{PROJECT_ROOT}/p2", "#{PROJECT_ROOT}/p3" ]
    DRB_URI = "druby://localhost:2250"
    SLEEP_TIME = 10
    COMMAND = "build.sh"
    RESULT = "result.txt"
    
    
    def self.start
      puts "Starting Server..."
      fork do
        begin
          DRb.start_service( DRB_URI, Rinda::TupleSpace.new ) 
          DRb.thread.join
        rescue Exception => e
          puts "Failed to start Blackboard Server: #{e}"
        end
      end
    end
    
    def initialize
    end

    def server
      DRb.start_service 
      
      tuplespace = Rinda::TupleSpaceProxy.new( DRbObject.new( nil, DRB_URI ) ) 
      
      loop do 
        projects.each do |project|
          ProcessGod.spawn do
            run_build = `cd #{project}; ./#{COMMAND} > #{RESULT}`
          end
        end
      
        sleep( SLEEP_TIME )
      end
      trap( "INT" ) do
        stop
      end
    end

    def stop( exit_code=0 )
      ProcessGod.reap
      DRb.stop_service
      exit exit_code
    end
    
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Starting build monkey..."
  Build::Monkey.start

  puts "Building projects like a monkey..."
  Build::Monkey.new.server  
end
