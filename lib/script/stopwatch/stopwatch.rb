module StopWatch
  
  class StopWatch
    
    USEC_SECS = 1000
    
    attr_accessor :start_time, :end_time
    
    def initialize(args={})
      args.each do |name, value|
        send("#{name}=", value)
      end
    end
    
    def start
      self.start_time = self.time
    end
    
    def stop
      self.end_time = self.time
    end
    
    # msecs diff
    def elapsed
      @elapsed ||= ->{
        ((self.end_time - self.start_time) * USEC_SECS).round unless (self.start_time.nil? || self.end_time.nil?)
      }.call
    end
    
    protected
    
    def start_time=(val)
      @elapsed = nil
      @start_time = val
    end
    
    def end_time=(val)
      @elapsed = nil
      @end_time = val
    end
    
    def time
      #now = Time.now
      #(now.to_f * USEC_SECS).round
      Time.now
    end
    
  end
  
end
