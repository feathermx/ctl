class Admin::Km < Km
  
  scope :list, ->{ select("kms.id, kms.track_count, kms.name, kms.captured_at") }
  
  def as_json(opts = {})
    super(opts.merge(methods: [:c_at]))
  end
  
  def captured_at=(val)
    write_attribute(:captured_at, time_val(val))
  end
  
  def list_elements(base)
    base.filter_by_km(self.id)
  end
  
  def find_track_by_id(id)
    Admin::Track.base.filter_by_km(self.id).filter_by_id(id).first
  end
  
  def find_traffic_count_by_id(id)
    Admin::TrafficCount.filter_by_km(self.id).filter_by_id(id).first
  end
  
end
