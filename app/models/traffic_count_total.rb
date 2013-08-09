class TrafficCountTotal < ActiveRecord::FmxBase
  
  module DayTime
    
    Morning = 0
    Evening = 1
    Noon = 2
    
    List = {
      Morning => {
        name: I18n.t('app.model.traffic_count_total.day_time.morning'),
        namespace: 'morning',
        starts_at: '00:00:00',
        ends_at: '10:59:59'
      },
      Noon => {
        name: I18n.t('app.model.traffic_count_total.day_time.noon'),
        namespace: 'noon',
        starts_at: '11:00:00',
        ends_at: '13:59:59'
      },
      Evening => {
        name: I18n.t('app.model.traffic_count_total.day_time.evening'),
        namespace: 'evening',
        starts_at: '14:00:00',
        ends_at: '23:59:59'
      }
    }
    
    def self.keys
      @@keys ||= List.keys
    end
    
  end
  
  scope :base, ->{ select('traffic_count_totals.id, traffic_count_totals.km_id, traffic_count_totals.morning_cars, traffic_count_totals.evening_cars, traffic_count_totals.noon_cars, traffic_count_totals.morning_taxis, traffic_count_totals.evening_taxis, traffic_count_totals.noon_taxis, traffic_count_totals.morning_pickup_trucks, traffic_count_totals.evening_pickup_trucks, traffic_count_totals.noon_pickup_trucks, traffic_count_totals.morning_articulated_trucks, traffic_count_totals.evening_articulated_trucks, traffic_count_totals.noon_articulated_trucks, traffic_count_totals.morning_rigid_trucks, traffic_count_totals.evening_rigid_trucks, traffic_count_totals.noon_rigid_trucks, traffic_count_totals.morning_vans, traffic_count_totals.evening_vans, traffic_count_totals.noon_vans, traffic_count_totals.morning_buses, traffic_count_totals.evening_buses, traffic_count_totals.noon_buses, traffic_count_totals.morning_bikes, traffic_count_totals.evening_bikes, traffic_count_totals.noon_bikes, traffic_count_totals.morning_motorbikes, traffic_count_totals.evening_motorbikes, traffic_count_totals.noon_motorbikes, traffic_count_totals.morning_pedestrians, traffic_count_totals.evening_pedestrians, traffic_count_totals.noon_pedestrians') }
  scope :base_count, ->{ select("COUNT(traffic_count_totals.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  scope :filter_by_km, ->(km_id){ where(km_id: km_id) }
  
  attr_protected :km_id, :morning_cars, :evening_cars, :noon_cars, :morning_taxis, :evening_taxis, :noon_taxis, :morning_pickup_trucks, :evening_pickup_trucks, :noon_pickup_trucks, :morning_articulated_trucks, :evening_articulated_trucks, :noon_articulated_trucks, :morning_rigid_trucks, :evening_rigid_trucks, :noon_rigid_trucks, :morning_vans, :evening_vans, :noon_vans, :morning_buses, :evening_buses, :noon_buses, :morning_bikes, :evening_bikes, :noon_bikes, :morning_motorbikes, :evening_motorbikes, :noon_motorbikes, :morning_pedestrians, :evening_pedestrians, :noon_pedestrians
  
  validates :km_id, :morning_cars, :evening_cars, :noon_cars, :morning_taxis, :evening_taxis, :noon_taxis, :morning_pickup_trucks, :evening_pickup_trucks, :noon_pickup_trucks, :morning_articulated_trucks, :evening_articulated_trucks, :noon_articulated_trucks, :morning_rigid_trucks, :evening_rigid_trucks, :noon_rigid_trucks, :morning_vans, :evening_vans, :noon_vans, :morning_buses, :evening_buses, :noon_buses, :morning_bikes, :evening_bikes, :noon_bikes, :morning_motorbikes, :evening_motorbikes, :noon_motorbikes, :morning_pedestrians, :evening_pedestrians, :noon_pedestrians, presence: true, numericality: { only_integer: true }
  
  def self.traffic_count_fields
    @@traffic_count_fields ||= %w{pedestrians cars motorbikes taxis pickup_trucks articulated_trucks rigid_trucks vans buses bikes}
  end
  
  def self.find_by_km(km_id)
    self.base.filter_by_km(km_id).first
  end
  
  def self.generate(km)
    el = self.new
    el.km_id = km.id
    self.traffic_count_fields.each do |field|
      el.set_field(field, km)
    end
    el
  end
  
  def set_field(name, km)
    DayTime::List.each do |key, val|
      timezone = km.time_zone
      field_setter = "#{val[:namespace]}_#{name}="
      starts = "TIME '#{val[:starts_at]}'"
      ends = "TIME '#{val[:ends_at]}'"
      base = TrafficCount.select("SUM(traffic_counts.#{name}) as num")
      self.send(field_setter, TrafficCount.peak_between(starts, ends, self.km_id, base, timezone))
    end
  end
  
  
end