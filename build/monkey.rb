require 'drb/drb'
require 'rinda/rinda'
require 'rinda/ring'
require 'rinda/tuplespace'

module Build
  class Monkey

    DRB_URI = "druby://localhost:2250"
    COMMAND = "build.sh"
    RESULT = "result.txt"
    
    def self.start
      begin
        fork do
          unless Thread.current[ :build_server ]
            puts "Starting Server ..."
            tuplespace = Rinda::TupleSpace.new
            DRb.start_service( DRB_URI, tuplespace )
            Thread.current[ :build_server ] = self
          end
          puts "Server started ..."
          DRb.thread.join
        end
      rescue Exception => e
        puts "Failed to start Blackboard Server: #{e}"
      end
    end

    def schedule( project_root )
      DRb.start_service 
      tuplespace = Rinda::TupleSpaceProxy.new( DRbObject.new( nil, DRB_URI ) ) 
      
      jobs = sanitize( project_root )
      jobs.each { |job| tuplespace.write( [:project, "#{project_root}/#{job}"] ) }
    end
    
    def sanitize( project_root )
      Dir.entries( "#{project_root}" ) - [ ".", ".." ]
    end
    
    def initialize
    end

    def server
      DRb.start_service 
      tuplespace = Rinda::TupleSpaceProxy.new( DRbObject.new( nil, DRB_URI ) ) 
      loop do 
        project = tuplespace.take( [:project, nil] )
        run_build = `cd #{project.last}; ./#{COMMAND} > #{RESULT}`
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
