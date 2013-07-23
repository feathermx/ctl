class Api::TrafficDisruption < TrafficDisruption
  
  module Json
    Default = {}
    Map = {
      only: [:vehicle_type, :lat, :lng]
    }
  end
  
  scope :api_map_base, ->{ select('traffic_disruptions.vehicle_type, traffic_disruptions.lat, traffic_disruptions.lng').with_location }
  
  def self.map_data(km_id, length_type)
    self.api_map_base.filter_by_km(km_id).filter_by_length_type(length_type)
  end
  
  def self.json_display
    @@json_display ||= Json::Default
  end
  
  def self.json_display=(val)
    @@json_display = val
  end
  
  def as_json(opts = {})
    super(opts.merge(self.class.json_display))
  end
  
  
  
end
