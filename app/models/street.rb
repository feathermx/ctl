class Street < ActiveRecord::FmxBase
  
  include Researchable
  
  scope :base, ->{ select("streets.id, streets.km_id, streets.block_id, streets.research_id, streets.public_meter_length, streets.dedicated_meter_length, streets.track_count") }
  scope :base_count, ->{ select("COUNT(streets.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  scope :filter_by_km, ->(km_id){ where(km_id: km_id) }
  scope :with_data, ->{ where('(streets.public_meter_length > 0 OR streets.dedicated_meter_length > 0)') }
  scope :research_ascending, ->{ order('streets.research_id ASC') }
  
  attr_protected :public_meter_length, :dedicated_meter_length, :track_count
  
  validates :km_id, :block_id, presence: true
  validates :km_id, numericality: { only_integer: true }
  validates :block_id, numericality: { only_integer: true }
  validates :public_meter_length, numericality: true, allow_nil: true
  validates :dedicated_meter_length, numericality: true, allow_nil: true
  validates :track_count, numericality: { only_integer: true }, allow_nil: true
  
  def set_meter_length
    data = StreetData.meter_base.filter_by_street(self.id).first
    self.public_meter_length = data[:public_meter_length].to_f
    self.dedicated_meter_length = data[:dedicated_meter_length].to_f
  end
  
  def set_track_count
    data = Track.base_count.filter_by_street(self.id).order(nil).first
    self.track_count = data[:num].to_i
  end
  
  
end