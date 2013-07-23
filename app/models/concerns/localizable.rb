module Localizable
  
  extend ActiveSupport::Concern
  
  included do
    
    attr_protected :lat, :lng
    
    def set_location
      self.lat = self.lng = nil
      track = nil
      base = Track.location_base.filter_by_km(self.km_id)
      time = self.send(self.location_field)
      before = base.filter_before(time).first
      after = base.filter_after(time).first
      if before.nil? || after.nil?
        track = before.nil? ? after : before
      else
        t = time.to_i
        diff_before = (before.tracked_at.to_i - t).abs
        diff_after = (after.tracked_at.to_i - t).abs
        track = (diff_before < diff_after) ? before : after
      end
      unless track.nil?
        self.lat, self.lng = track.lat, track.lng
      end
    end
    
    protected
    
    def location_field
      raise NotImplementedError
    end
    
  end
  
  
end