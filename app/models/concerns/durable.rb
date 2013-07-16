module Durable
  
  extend ActiveSupport::Concern
  
  module ClassMethods
    
    def duration_base
      self.select('traffic_disruptions.started_at, traffic_disruptions.ended_at')
    end
    
    def duration_for_hour(hour, km_id)
      duration = 0
      starts = "TIME '#{hour}:00:00'"
      ends = "TIME '#{hour}:59:59'"
      self.duration_base.filter_between(starts, ends, km_id).each do |el|
        duration = duration + (el.duration)
      end
      duration
    end
     
  end
  
  included do
    
    def duration
      @duration ||= (self.ended_at.to_i - self.started_at.to_i).abs
    end 
    
  end
  
  
end