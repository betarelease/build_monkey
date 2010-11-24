module Build
  class ProcessGod
    
    @@children = []
    def self.spawn( count=1, &block )
      count.times do
        @@children << fork( &block )
      end
    end
    
    def self.reap
      puts "Reaping #{@@children.size} child processes"
      @@children.each do |pid|
        begin
          Process.kill 9, pid
        rescue Errno::ESRCH
          # Ignore.  That pid is already dead.
        end
      end
    end
        
  end
end