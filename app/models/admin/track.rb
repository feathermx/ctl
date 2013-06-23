class Admin::Track < Track
  
  include MassInsertable
  include DateStringable
  
  scope :list, ->{ select("tracks.id, tracks.lat, tracks.lng, tracks.tracked_at") }
  
  def lng=(val)
    val = (val.to_f * -1) unless val.nil?
    write_attribute(:lng, val)
  end
  
  def time=(val)
    @time = val
    self.update_tracked_at
  end
  
  def time
    @time
  end
  
  def date=(val)
    val = date_str(val, "/", "mdy")
    @date = val
    self.update_tracked_at
  end
  
  def date
    @date
  end
  
  def as_json(opts = {})
    super(opts.merge(methods: [:t_at]))
  end
  
  protected
  
  def update_tracked_at
    unless self.date.nil? || self.time.nil?
      self.tracked_at = Time.parse("#{self.date} #{self.time} +00:00")
    end
  end
  
end