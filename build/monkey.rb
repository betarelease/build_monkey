require 'logger'
require 'singleton'
require 'drb/drb'
require 'rinda/rinda'
require 'rinda/ring'
require 'rinda/tuplespace'

module Build
  class Monkey
    
    include Singleton
    
    DRB_URI = "druby://localhost:2250"
    BUILD_COMMAND = "build.sh"
    RESULT_FILE = "result.txt"
    
    def log
      unless @log
        @log = Logger.new(STDOUT) 
        @log.level = Logger::DEBUG
      end
      @log
    end
    
    def run
      DRb.start_service 
      tuplespace = Rinda::TupleSpaceProxy.new( DRbObject.new( nil, DRB_URI ) ) 
      loop do 
        project = tuplespace.take( [:project, nil] )
        command = "cd #{project.last}; ./#{BUILD_COMMAND} > #{RESULT_FILE}"
        log.info "Running #{command}"
        run_build = `#{command}`
        log.info "Finished #{command}"
      end
      
      trap( "INT" ) do
        stop -1
      end
    end

    def sanitize( project_root )
      Dir.entries( "#{project_root}" ) - [ ".", ".." ]
    end
    
    def schedule( project_root )
      DRb.start_service 
      tuplespace = Rinda::TupleSpaceProxy.new( DRbObject.new( nil, DRB_URI ) ) 
      
      jobs = sanitize( project_root )
      jobs.each { |job| tuplespace.write( [:project, "#{project_root}/#{job}"] ) }
    end
        
    def server
      begin
        fork do
          unless Thread.current[ :build_server ]
            log.info "Starting Server ..."
            tuplespace = Rinda::TupleSpace.new
            DRb.start_service( DRB_URI, tuplespace )
            Thread.current[ :build_server ] = self
          end
          log.info "Server started ..."
          DRb.thread.join
        end
      rescue Exception => e
        log.error "Failed to start Blackboard Server: #{e}"
      end
    end

    def stop( exit_code=0 )
      DRb.stop_service
      log.error "Exiting with exit_code #{exit_code}"
      exit exit_code
    end
    
  end
end
