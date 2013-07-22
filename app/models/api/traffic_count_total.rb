class Api::TrafficCountTotal < TrafficCountTotal
  
  module Json
    Default = {}
  end
  
  scope :api_chart_base, ->{ select('traffic_count_totals.morning_cars, traffic_count_totals.evening_cars, traffic_count_totals.noon_cars, traffic_count_totals.morning_taxis, traffic_count_totals.evening_taxis, traffic_count_totals.noon_taxis, traffic_count_totals.morning_pickup_trucks, traffic_count_totals.evening_pickup_trucks, traffic_count_totals.noon_pickup_trucks, traffic_count_totals.morning_articulated_trucks, traffic_count_totals.evening_articulated_trucks, traffic_count_totals.noon_articulated_trucks, traffic_count_totals.morning_rigid_trucks, traffic_count_totals.evening_rigid_trucks, traffic_count_totals.noon_rigid_trucks, traffic_count_totals.morning_vans, traffic_count_totals.evening_vans, traffic_count_totals.noon_vans, traffic_count_totals.morning_buses, traffic_count_totals.evening_buses, traffic_count_totals.noon_buses, traffic_count_totals.morning_bikes, traffic_count_totals.evening_bikes, traffic_count_totals.noon_bikes, traffic_count_totals.morning_motorbikes, traffic_count_totals.evening_motorbikes, traffic_count_totals.noon_motorbikes, traffic_count_totals.morning_pedestrians, traffic_count_totals.evening_pedestrians, traffic_count_totals.noon_pedestrians') }
  
  def self.json_display
    @@json_display ||= Json::Default
  end
  
  def self.json_display=(val)
    @@json_display = val
  end
  
  def self.find_chart_base_by_km(km_id)
    self.api_chart_base.filter_by_km(km_id).first
  end
  
  def as_json(opts = {})
    super(opts.merge(self.class.json_display))
  end
  
  def as_chart
    @as_chart || ->{
      data = {}
      self.class.traffic_count_fields.each do |field|
        totals = {}
        DayTime::List.each do |key, el|
          namespace = el[:namespace]
          field_name = "#{namespace}_#{field}"
          totals[namespace] = self.send(field_name)
        end
        data[field] = totals
      end
      data
    }.call
  end
  
  
end
