class ParkingRestriction < ActiveRecord::FmxBase
  
  scope :base, ->{ select("parking_restrictions.id, parking_restrictions.street_id, parking_restrictions.day_of_week, parking_restrictions.starts_at, parking_restrictions.ends_at, parking_restrictions.parking_duration, parking_restrictions.notes") }
  scope :base_count, ->{ select("COUNT(parking_restrictions.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  
  
end