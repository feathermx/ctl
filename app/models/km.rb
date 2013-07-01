class Km < ActiveRecord::FmxBase

  scope :base, ->{ select("kms.id, kms.tracks_count, kms.traffic_counts_count, kms.traffic_disruptions_count, kms.street_data_count, kms.parking_restrictions_count, kms.shops_count, kms.deliveries_count, kms.city_id, kms.name, kms.description, kms.comments, kms.lat, kms.lng") }
  scope :base_count, ->{ select("COUNT(kms.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  scope :filter_by_city, ->(city_id){ where(city_id: city_id) }

  attr_protected :city_id, :track_count, :traffic_count_count, :traffic_disruption_count, :street_data_count, :parking_restriction_count, :shop_count, :delivery_count

  validates :city_id, :name, :lat, :lng, presence: true
  validates :city_id, numericality: { only_integer: true }
  validates :name, length: { in: 2..100 }
  validates :description, length: { in: 2..300 }, allow_blank: true
  validates :comments, length: { in: 2..300 }, allow_blank: true
  validates :lat, numericality: true
  validates :lng, numericality: true
  
  
end