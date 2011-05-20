module Build
  class Job
    
    def initialize(project)
      @project = project
    end
    
    def build
      build_command, result_file = find
      command = "cd #{@project}; ./#{build_command} > #{result_file}"
      LOGGER.info "Running #{command}"
      run_build = `#{command}`
      LOGGER.info "Finished #{command}"
    end

    def find
      files = Dir.entries(@project) - [".", ".."]
      build_command = files.find {|c| c =~ /.sh/}
      result_file = files.find {|r| r =~ /result/}
      result_file ||= "result.txt"
      return build_command, result_file
    end
    
  end
end
