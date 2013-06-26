class TrafficCount < ActiveRecord::FmxBase
  
  include BlockStreetable
  include DateParsable
  
  scope :base, ->{ select("traffic_counts.id, traffic_counts.km_id, traffic_counts.street_id. traffic_counts.started_at, traffic_counts.ended_at, traffic_counts.cars, traffic_counts.taxis, traffic_counts.pickup_trucks, traffic_counts.articulated_trucks, traffic_counts.rigid_trucks, traffic_counts.vans, traffic_counts.buses, traffic_counts.bikes, traffic_counts.motorbikes, traffic_counts.pedestrians, traffic_counts.notes") }
  scope :base_count, ->{ select("COUNT(traffic_counts.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }

  validates :started_at, presence: true
  validates :ended_at, presence: true
  validates :cars, numericality: { only_integer: true }, allow_blank: true
  validates :taxis, numericality: { only_integer: true }, allow_blank: true
  validates :pickup_trucks, numericality: { only_integer: true }, allow_blank: true
  validates :articulated_trucks, numericality: { only_integer: true }, allow_blank: true
  validates :rigid_trucks, numericality: { only_integer: true }, allow_blank: true
  validates :vans, numericality: { only_integer: true }, allow_blank: true
  validates :buses, numericality: { only_integer: true }, allow_blank: true
  validates :bikes, numericality: { only_integer: true }, allow_blank: true
  validates :motorbikes, numericality: { only_integer: true }, allow_blank: true
  validates :pedestrians, numericality: { only_integer: true }, allow_blank: true
  validates :notes, length: { in: 2..300 }, allow_blank: true
  
  def started_at=(val) 
    write_attribute(:started_at, date_time_val(val))
  end
  
  def ended_at=(val) 
    write_attribute(:ended_at, date_time_val(val))
  end
  
  
  
end
