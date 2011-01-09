require 'drb/drb'
require 'rinda/rinda'
require 'rinda/ring'
require 'rinda/tuplespace'

module Build
  class Monkey

    PROJECT_ROOT = "./projects"
    PROJECTS = [ "#{PROJECT_ROOT}/p1", "#{PROJECT_ROOT}/p2", "#{PROJECT_ROOT}/p3" ]
    DRB_URI = "druby://localhost:2250"
    SLEEP_TIME = 10
    COMMAND = "build.sh"
    RESULT = "result.txt"
    
    
    def self.start
      begin
        fork do
          unless Thread.current[:build_server]
            puts "Starting Server..."
            tuplespace = Rinda::TupleSpace.new
            tuplespace.write([:project, "#{PROJECT_ROOT}/p1"])
            tuplespace.write([:project, "#{PROJECT_ROOT}/p2"])
            tuplespace.write([:project, "#{PROJECT_ROOT}/p3"])
            # ::Rinda::RingServer.new tuplespace
          
            DRb.start_service( DRB_URI, tuplespace )
            Thread.current[:build_server] = self
          end
          puts "Server started ..."
          DRb.thread.join
        end
      rescue Exception => e
        puts "Failed to start Blackboard Server: #{e}"
      end
    end
    
    def initialize
    end

    def server
      DRb.start_service 
      puts "In server..."
      tuplespace = Rinda::TupleSpaceProxy.new( DRbObject.new( nil, DRB_URI ) ) 
      # tuplespace = ::Rinda::RingFinger.primary

      
      project = tuplespace.take( [:project, nil] )
      
      run_build = `cd #{project}; ./#{COMMAND} > #{RESULT}`
      
      # loop do 
      #   PROJECTS.each do |project|
      #     Build::ProcessGod.spawn do
      #       run_build = `cd #{project}; ./#{COMMAND} > #{RESULT}`
      #     end
      #   end
      # 
      #   sleep( SLEEP_TIME )
      # end
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
