class Km < ActiveRecord::FmxBase

  scope :base, ->{ select("kms.id, kms.track_count, kms.city_id, kms.name, kms.description, kms.comments, kms.lat, kms.lng, kms.captured_at") }
  scope :base_count, ->{ select("COUNT(kms.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  scope :filter_by_city, ->(city_id){ where(city_id: city_id) }

  attr_protected :city_id, :track_count

  validates :city_id, :name, :lat, :lng, :captured_at, presence: true
  validates :city_id, numericality: { only_integer: true }
  validates :name, length: { in: 2..100 }
  validates :description, length: { in: 2..300 }, allow_blank: true
  validates :comments, length: { in: 2..300 }, allow_blank: true
  validates :lat, numericality: true
  validates :lng, numericality: true
  
  def c_at
    @c_at ||= ->{
      (self.captured_at.to_time.to_i * 1000) unless self.captured_at.nil?
    }.call
  end
  
end