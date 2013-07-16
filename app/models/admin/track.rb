class Admin::Track < Track
  
  INVERT_LAT = 's'
  INVERT_LNG = 'w'
  
  include MassInsertable
  include DateTimeable
  
  scope :list, ->{ select("tracks.id, tracks.lat, tracks.lng, tracks.tracked_at") }
  
  attr_accessor :lat_dir, :lng_dir
  attr_protected :tracked_at
  
  before_save :set_location
  
  def lng_dir
    @lng_dir ||= 1
  end
  
  def lat_dir
    @lat_dir ||= 1
  end
  
  def lat_dir=(val)
    unless val.blank?
      val.downcase!
      @lat_dir = -1 if val == INVERT_LAT
    end
  end
  
  def lng_dir=(val)
    unless val.blank?
      val.downcase!
      @lng_dir = -1 if val == INVERT_LNG
    end
  end
  
  def as_json(opts = {})
    super(opts.merge(methods: [:t_at]))
  end
  
  protected
  
  def set_location
    self.lat = self.lat * self.lat_dir unless self.lat.nil?
    self.lng = self.lng * self.lng_dir unless self.lng.nil?
  end
  
  def date_time_fields
    @date_time_fields ||= [
      DateTimeField.new(name: 'tracked_at', required: true, date_order: 'Ymd')
    ]
  end
  
end