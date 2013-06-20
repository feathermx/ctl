class Track < ActiveRecord::FmxBase
  
  scope :base, ->{ select("tracks.id, tracks.km_id, tracks.lat, tracks.lng, tracks.tracked_at") }
  scope :base_count, ->{ select("COUNT(tracks.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  scope :filter_by_km, ->(km_id){ where(km_id: km_id) }
  
  attr_protected :km_id
  
  validates :km_id, :lat, :lng, :tracked_at, presence: true
  validates :lat, numericality: true
  validates :lng, numericality: true
  
  after_create :add_km_count
  before_destroy :substract_km_count
  
  def t_at
    @t_at ||= ->{
      (self.tracked_at.to_time.to_i * 1000) unless self.tracked_at.nil?
    }.call
  end
  
  protected
  
  def km
    @km ||= Km.find_by_id(self.km_id)
  end
  
  def add_km_count
    self.km.track_count = self.km.track_count.to_i + 1
    self.km.save
  end
  
  def substract_km_count
    self.km.track_count = self.km.track_count.to_i - 1
    self.km.save
  end
  
  
end