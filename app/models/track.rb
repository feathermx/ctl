class Track < ActiveRecord::FmxBase
  
  include Kmable
  
  scope :base, ->{ select("tracks.id, tracks.km_id, tracks.street_id, tracks.lat, tracks.lng, tracks.tracked_at") }
  scope :base_count, ->{ select("COUNT(tracks.id) as num") }
  scope :location_base, ->{ select('tracks.lat, tracks.lng, tracks.tracked_at') }
  scope :filter_by_id, ->(id){ where(id: id) }
  scope :filter_by_street, ->(street_id){ where(street_id: street_id) }
  scope :filter_after, ->(time){ where('tracks.tracked_at >= ?', time).order('tracks.tracked_at ASC') }
  scope :filter_before, ->(time){ where('tracks.tracked_at <= ?', time).order('tracks.tracked_at DESC') }
  scope :ascending, ->{ order('tracks.tracked_at ASC') }
  
  attr_protected :street_id
  
  validates :lat, :lng, :tracked_at, presence: true
  validates :street_id, numericality: { only_integer: true }, allow_nil: true
  validates :lat, numericality: true
  validates :lng, numericality: true
  
  def t_at
    @t_at ||= ->{
      (self.tracked_at.to_time.to_i * 1000) unless self.tracked_at.nil?
    }.call
  end
  
  def set_street_id
    self.street_id = nil
    shop = nil
    base = Shop.find_for_track(self.km_id)
    before = base.filter_before(self.tracked_at).first
    after = base.filter_after(self.tracked_at).first
    if after.nil? || before.nil?
      shop = after.nil? ? before : after
    else
      t_at = self.tracked_at.to_i
      diff_after = (after.registered_at.to_i - t_at).abs
      diff_before = (before.registered_at.to_i - t_at).abs
      shop = (diff_after < diff_before) ? after : before
    end
    self.street_id = shop.street_id unless shop.nil?
  end
  
end