class ParkingRestriction < ActiveRecord::FmxBase

  include BlockStreetable
  include DateParsable
  include Kmable
  include Weekable
  
  scope :base, ->{ select("parking_restrictions.id, parking_restrictions.km_id, parking_restrictions.street_id, parking_restrictions.day_of_week, parking_restrictions.starts_at, parking_restrictions.ends_at, parking_restrictions.parking_duration, parking_restrictions.notes") }
  scope :base_count, ->{ select("COUNT(parking_restrictions.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :day_of_week, presence: true, numericality: { only_integer: true }
  validates :parking_duration, numericality: true, allow_blank: true
  validates :notes, length: { in: 2..300 }, allow_blank: true
  
  def s_at
    @s_at ||= ->{
      (self.starts_at.to_i * 1000) unless self.starts_at.nil?
    }.call
  end
  
  def e_at
    @e_at ||= ->{
      (self.ends_at.to_i * 1000) unless self.ends_at.nil?
    }.call
  end
  
  def starts_at=(val)
    write_attribute(:starts_at, time_val(val))
  end
  
  def ends_at=(val)
    write_attribute(:ends_at, time_val(val))
  end
  
  def day_of_week=(val)
    write_attribute(:day_of_week, week_val(val))
  end
  
end