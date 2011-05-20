module Build
  class Monkey
    
    include Singleton
    
    DRB_URI = "druby://localhost:2250"
    BUILD_COMMAND = "build.sh"
    RESULT_FILE = "result.txt"
    
    def run
      puts "running "
      DRb.start_service 
      tuplespace = Rinda::TupleSpaceProxy.new( DRbObject.new( nil, DRB_URI ) ) 
      loop do 
        project = tuplespace.take( [:project, nil] )
        job = Job.new(project.last)
        job.build
      end
      
      trap( "INT" ) do
        stop -1
      end
    end

    def schedule( project_root )
      DRb.start_service 
      tuplespace = Rinda::TupleSpaceProxy.new( DRbObject.new( nil, DRB_URI ) ) 
      publisher = Publisher.new(project_root)
      publisher.publish(tuplespace)
    end
        
    def server
      begin
        fork do
          unless Thread.current[ :build_server ]
            LOGGER.info "Starting Server ..."
            tuplespace = Rinda::TupleSpace.new
            DRb.start_service( DRB_URI, tuplespace )
            Thread.current[ :build_server ] = self
          end
          LOGGER.info "Server started ..."
          DRb.thread.join
        end
      rescue Exception => e
        LOGGER.error "Failed to start Blackboard Server: #{e}"
      end
    end

    def stop( exit_code=0 )
      DRb.stop_service
      LOGGER.error "Exiting with exit_code #{exit_code}"
      exit exit_code
    end
    
  end
end
