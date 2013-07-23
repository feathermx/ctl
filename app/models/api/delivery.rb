class Api::Delivery < Delivery
  
  module Json
    Default = {}
    Chart = {
      only: [],
      methods: [:s_at, :e_at]
    }
    Map = {
      only: [:vehicle_type, :delivering_company, :lat, :lng],
      methods: [:duration]
    }
  end
  
  scope :api_chart_base, ->{ select('deliveries.started_at, deliveries.ended_at') }
  scope :api_map_base, ->{ select('deliveries.vehicle_type, deliveries.delivering_company, deliveries.started_at, deliveries.ended_at, deliveries.lat, deliveries.lng') }
  
  def self.map_data(km_id, delivery_type)
    self.api_map_base.filter_by_km(km_id).filter_by_type(delivery_type)
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
