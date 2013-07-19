class Api::DeliveriesDisruption < DeliveriesDisruption
  
  module Json
    Default = {}
    DeliveriesChart = {
      only: [:delivery_count],
      methods: [:hour_i]
    }
  end
  
  scope :api_deliveries_chart_base, ->{ select('deliveries_disruptions.hour, deliveries_disruptions.delivery_count').with_delivery_data.ascending_deliveries }
  
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
