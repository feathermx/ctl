class Api::DeliveriesController < Api::ApiController
  
  include Api::Kmable
  
  before_filter :assert_km, only: [:chart, :map]
  
  # POST /api/deliveries/chart
  def chart
    Api::Delivery.json_display = Api::Delivery::Json::Chart
    render json: { 
      contents: {
        starts_at: self.km.min_delivery_time_at, 
        ends_at: self.km.max_delivery_time_at, 
        elements: self.km.api_chart_deliveries
      }
    }
  end
  
  # POST /api/deliveries/map
  def map
    Api::Delivery.json_display = Api::Delivery::Json::Map
    render json: { contents: self.km.api_map_deliveries }
  end
  
  
end
