class Track < ActiveRecord::FmxBase
  
  include Kmable
  
  scope :base, ->{ select("tracks.id, tracks.km_id, tracks.lat, tracks.lng, tracks.tracked_at") }
  scope :base_count, ->{ select("COUNT(tracks.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  
  validates :lat, :lng, :tracked_at, presence: true
  validates :lat, numericality: true
  validates :lng, numericality: true
  
  def t_at
    @t_at ||= ->{
      (self.tracked_at.to_time.to_i * 1000) unless self.tracked_at.nil?
    }.call
  end
  
end