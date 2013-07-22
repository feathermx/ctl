class Api::DeliveriesDisruption < DeliveriesDisruption
  
  module Json
    Default = {}
    Chart = {
      only: [:disruption_count, :delivery_count],
      methods: [:hour_i]
    }
  end
  
  scope :api_chart_base, ->{ select('deliveries_disruptions.hour, deliveries_disruptions.disruption_count, deliveries_disruptions.delivery_count').ascending }
  
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
