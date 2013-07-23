class TrafficCount < ActiveRecord::FmxBase
  
  include BlockStreetable
  include DateParsable
  include Kmable
  include Peakable
  
  scope :base, ->{ select("traffic_counts.id, traffic_counts.km_id, traffic_counts.street_id, traffic_counts.started_at, traffic_counts.ended_at, traffic_counts.cars, traffic_counts.taxis, traffic_counts.pickup_trucks, traffic_counts.articulated_trucks, traffic_counts.rigid_trucks, traffic_counts.vans, traffic_counts.buses, traffic_counts.bikes, traffic_counts.motorbikes, traffic_counts.pedestrians, traffic_counts.traffic_total, traffic_counts.notes") }
  scope :peak_base, ->{ select('SUM(traffic_counts.traffic_total) as num') }
  scope :base_count, ->{ select("COUNT(traffic_counts.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  
  attr_protected :traffic_total
  
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
  
  before_save :set_total
  
  def s_at
    @s_at ||= ->{
      (self.started_at.to_i * 1000) unless self.started_at.nil?
    }.call
  end
  
  def e_at
    @e_at ||= ->{
      (self.ended_at.to_i * 1000) unless self.ended_at.nil?
    }.call
  end
  
  def started_at=(val) 
    write_attribute(:started_at, date_time_val(val))
  end
  
  def ended_at=(val) 
    write_attribute(:ended_at, date_time_val(val))
  end
  
  protected
  
  def set_total
    self.traffic_total = self.cars.to_i + self.taxis.to_i + self.pickup_trucks.to_i + self.articulated_trucks.to_i + self.rigid_trucks.to_i + self.vans.to_i + self.buses.to_i + self.bikes.to_i + self.motorbikes.to_i + self.pedestrians.to_i
  end
  
  def self.peak_field
    "started_at"
  end
  
  
end
