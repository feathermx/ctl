class Api::DeliveryTotal < DeliveryTotal
  
  module Json
    Default = {}
    Chart = {
      only: [:total_sun, :total_mon, :total_tue, :total_wed, :total_thu, :total_fri, :total_sat],
      methods: [:hour_i]
    }
  end
  
  scope :api_chart_base, ->{ select('delivery_totals.km_id, delivery_totals.hour, delivery_totals.total_sun, delivery_totals.total_mon, delivery_totals.total_tue, delivery_totals.total_wed, delivery_totals.total_thu, delivery_totals.total_fri, delivery_totals.total_sat').ascending }
  
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