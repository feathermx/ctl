class Street < ActiveRecord::FmxBase
  
  include Researchable
  
  scope :base, ->{ select("streets.id, streets.km_id, streets.block_id, streets.research_id, streets.public_meter_length, streets.dedicated_meter_length, streets.track_count, streets.lat1, streets.lng1, streets.lat2, streets.lng2") }
  scope :base_count, ->{ select("COUNT(streets.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  scope :filter_by_km, ->(km_id){ where(km_id: km_id) }
  scope :with_data, ->{ where('(streets.public_meter_length > 0 OR streets.dedicated_meter_length > 0)') }
  scope :with_location, ->{ where('streets.lat1 IS NOT NULL AND streets.lng1 IS NOT NULL AND streets.lat2 IS NOT NULL AND streets.lng2 IS NOT NULL') }
  scope :research_ascending, ->{ order('streets.research_id ASC') }
  
  attr_protected :public_meter_length, :dedicated_meter_length, :track_count, :lat1, :lng1, :lat2, :lng2
  
  validates :km_id, :block_id, presence: true
  validates :km_id, numericality: { only_integer: true }
  validates :block_id, numericality: { only_integer: true }
  validates :public_meter_length, numericality: true, allow_nil: true
  validates :dedicated_meter_length, numericality: true, allow_nil: true
  validates :track_count, numericality: { only_integer: true }, allow_nil: true
  validates :lat1, numericality: true, allow_nil: true
  validates :lng1, numericality: true, allow_nil: true
  validates :lat2, numericality: true, allow_nil: true
  validates :lng2, numericality: true, allow_nil: true
  validates :research_id, uniqueness: { scope: :block_id }
  
  def set_location(pr=nil)
    if pr.nil?
      self.do_set_location
    else
      pr.exec(:StreetsLocation) do
        self.do_set_location
      end
    end
  end
  
  def set_meter_length(pr=nil)
    if pr.nil?
      self.do_set_meter_length
    else
      pr.exec(:StreetsMeterLength) do
        self.do_set_meter_length
      end
    end
  end
  
  def set_track_count(pr=nil)
    if pr.nil?
      self.do_set_track_count
    else
      pr.exec(:StreetsTrackCount) do
        self.do_set_track_count
      end
    end
    
  end
  
  protected
  
  def do_set_location
    total = Track.base_count.filter_by_street(self.id).order(nil).first[:num].to_i
    if total > 0
      half = (total / 2)
      quarter = (half / 2)
      first = Track.location_base.filter_by_street(self.id).ascending.limit(1).offset(quarter).first
      last = Track.location_base.filter_by_street(self.id).ascending.limit(1).offset(half + quarter).first
      self.lat1, self.lng1 = first.lat, first.lng
      self.lat2, self.lng2 = last.lat, last.lng
    end
  end
  
  def do_set_meter_length
    data = StreetData.meter_base.filter_by_street(self.id).first
    self.public_meter_length = data[:public_meter_length].to_f
    self.dedicated_meter_length = data[:dedicated_meter_length].to_f
  end
  
  def do_set_track_count
    data = Track.base_count.filter_by_street(self.id).order(nil).first
    self.track_count = data[:num].to_i
  end
  
  
end