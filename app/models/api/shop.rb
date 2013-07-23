class Api::Shop < Shop
  
  module Json
    Default = {}
    Chart = {
      only: [:name],
      methods: [:chart_deliveries]
    }
    Map = {
      only: [:name, :lat, :lng],
      methods: [:f_length]
    }
  end
  
  scope :api_chart_base, ->{ select('shops.id, shops.name').with_deliveries.ascending }
  scope :api_map_base, ->{ select('shops.name, shops.front_length, shops.lat, shops.lng') }
  
  def self.map_data(km_id, shop_type)
    self.api_map_base.filter_by_km(km_id).filter_by_type(shop_type)
  end
  
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
