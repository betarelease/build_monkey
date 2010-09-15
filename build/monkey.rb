require 'drb/drb'
require 'rinda/rinda' 
require 'rinda/tuplespace' 

module Build
  class Monkey

    PROJECT_ROOT = "./projects"
    DRB_URI = "druby://localhost:2250"
    SLEEP_TIME = 10
    attr_reader :children
    
    def self.start
      puts "Spawning queue server"
      fork do
        begin
          DRb.start_service(DRB_URI, Rinda::TupleSpace.new) 
          DRb.thread.join
        rescue Exception => e
          puts "Failed to start Blackboard Server: #{e}"
        end
      end
    end
    
    def initialize
      @children = []
    end

    def server
      DRb.start_service 
      
      tuplespace = Rinda::TupleSpaceProxy.new(DRbObject.new(nil, DRB_URI)) 
      
      loop do 
        projects = ["#{PROJECT_ROOT}/p1", "#{PROJECT_ROOT}/p2", "#{PROJECT_ROOT}/p3"]
        projects.each do |project|
          spawn_process do
            run_build = `cd #{project}; ./build.sh > result.txt`
          end
        end
      
        sleep(SLEEP_TIME)
      end
      trap("INT") do
        reap
        DRb.stop_service
      end
    end

    def spawn_process( count=1, &block )
      count.times do
        children << fork( &block )
      end
    end
    
    def reap( exit_code=0 )
      info "Reaping #{children.size} child processes"
      children.each do |pid|
        begin
          Process.kill 9, pid
        rescue Errno::ESRCH
          # Ignore.  That pid is already dead.
        end
      end

      exit exit_code
    end
    
    
  end
end

puts "Starting build monkey..."
Build::Monkey.start

puts "Building projects like a monkey..."
Build::Monkey.new.server
