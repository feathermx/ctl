class Api::Street < Street
  
  module Json
    Default = {}
    Chart = {
      only: [:research_id, :public_meter_length, :dedicated_meter_length]
    }
  end
  
  scope :api_chart_base, ->{ select('streets.research_id, streets.public_meter_length, streets.dedicated_meter_length').chart_order.with_data.research_ascending }
  scope :chart_order, ->{ order('streets.public_meter_length DESC, streets.dedicated_meter_length DESC')  }
  
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
