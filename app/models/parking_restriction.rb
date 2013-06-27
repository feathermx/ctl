class ParkingRestriction < ActiveRecord::FmxBase

  include BlockStreetable
  include DateParseable
  
  scope :base, ->{ select("parking_restrictions.id, parking_restrictions.km_id, parking_restrictions.street_id, parking_restrictions.day_of_week, parking_restrictions.starts_at, parking_restrictions.ends_at, parking_restrictions.parking_duration, parking_restrictions.notes") }
  scope :base_count, ->{ select("COUNT(parking_restrictions.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  
  validates :day_of_week, presence: true, numericality: { only_integer: true }
  
  def starts_at=(val) 
    write_attribute(:starts_at, date_time_val(val))
  end
  
  def ends_at=(val) 
    write_attribute(:ends_at, date_time_val(val))
  end
  
end
