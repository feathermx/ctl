class Api::Shop < Shop
  
  module Json
    Default = {}
    Chart = {
      only: [:name],
      methods: [:chart_deliveries]
    }
  end
  
  scope :api_chart_base, ->{ select('shops.id, shops.name').ascending }
  
  def chart_deliveries
    Api::Delivery.json_display = Api::Delivery::Json::Chart
    @chart_deliveries ||= Api::Delivery.api_chart_base.filter_by_shop(self.id)
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
