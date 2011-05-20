module Build
  class Publisher
    
    def initialize(project_root)
      @project_root = project_root
    end
    
    def sanitized_jobs
      Dir.entries( "#{@project_root}" ) - [ ".", ".." ]
    end
     
    def publish(tuplespace)
      sanitized_jobs.each { |job| tuplespace.write( [:project, "#{@project_root}/#{job}"] ) }
    end
    
  end
end