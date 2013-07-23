class Api::TrafficDisruption < TrafficDisruption
  
  module Json
    Default = {}
    Map = {
      only: [:vehicles_affected, :lat, :lng],
      methods: [:source_name, :duration]
    }
  end
  
  scope :api_map_base, ->{ select('traffic_disruptions.vehicles_affected, traffic_disruptions.source, traffic_disruptions.lat, traffic_disruptions.lng, traffic_disruptions.started_at, traffic_disruptions.ended_at').with_location }
  
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
