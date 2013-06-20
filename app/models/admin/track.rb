class Admin::Track < Track
  
  scope :list, ->{ select("tracks.id, tracks.lat, tracks.lng, tracks.tracked_at") }
  
  def as_json(opts = {})
    super(opts.merge(methods: [:t_at]))
  end
  
  def captured_at=(val)
    write_attribute(:tracked_at, time_val(val))
  end
  
end
