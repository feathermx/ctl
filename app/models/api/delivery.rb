class Api::Delivery < Delivery
  
  module Json
    Default = {}
    Chart = {
      only: [],
      methods: [:s_at, :e_at]
    }
  end
  
  scope :api_chart_base, ->{ select('deliveries.started_at, deliveries.ended_at') }
  
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
