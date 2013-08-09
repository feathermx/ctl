class Api::DeliveriesController < Api::ApiController
  
  include Api::Kmable
  
  before_filter :assert_km, only: [:chart, :map]
  
  # POST /api/deliveries/chart
  def chart
    Api::DeliveryTotal.json_display = Api::DeliveryTotal::Json::Chart
    render json: { contents: self.km.api_chart_deliveries }
  end
  
  # POST /api/deliveries/map
  def map
    Api::Delivery.json_display = Api::Delivery::Json::Map
    render json: { contents: self.km.api_map_deliveries }
  end
  
  
end
