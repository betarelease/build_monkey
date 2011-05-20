module Build
  class Publisher
    
    def initialize(project_root)
      @project_root = project_root
    end
    
    def sanitize
      Dir.entries( "#{@project_root}" ) - [ ".", ".." ]
    end
     
    def publish(tuplespace)
      jobs = sanitize
      jobs.each { |job| tuplespace.write( [:project, "#{@project_root}/#{job}"] ) }
    end
    
  end
end