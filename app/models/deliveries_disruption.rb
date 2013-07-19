class DeliveriesDisruption < ActiveRecord::FmxBase
  
  scope :base, ->{ select('deliveries_disruptions.id, deliveries_disruptions.km_id, deliveries_disruptions.hour, deliveries_disruptions.disruption_count, deliveries_disruptions.delivery_count') }
  scope :base_count, ->{ select("COUNT(deliveries_disruptions.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  scope :filter_by_km, ->(km_id){ where(km_id: km_id) }
  scope :with_delivery_data, ->{ where('deliveries_disruptions.delivery_count > 0') }
  scope :ascending_deliveries, ->{ order('deliveries_disruptions.hour ASC') }
  
  attr_protected :km_id, :hour, :disruption_count, :delivery_count
  
  validates :km_id, :hour, :disruption_count, :delivery_count, presence: true
  validates :km_id, numericality: { only_integer: true }
  validates :disruption_count, numericality: { only_integer: true }
  validates :delivery_count, numericality: { only_integer: true }
  
  def self.generate(hour, km)
    el = self.new
    el.km_id = km.id
    el.hour = "#{hour}:00:00 +00:00"
    el.disruption_count = TrafficDisruption.duration_for_hour(hour, km.id)
    el.delivery_count = Delivery.duration_for_hour(hour, km.id)
    el
  end
  
  def hour_i
    @hour_i ||= self.hour.hour
  end
  
  
end
