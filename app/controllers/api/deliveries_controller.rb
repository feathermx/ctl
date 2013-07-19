class Api::DeliveriesController < Api::ApiController
  
  include Api::Kmable
  
  before_filter :assert_km, only: [:chart]
  
  # POST /api/deliveries/chart
  def chart
    Api::Shop.json_display = Api::Shop::Json::Chart
    render json: { starts_at: self.km.min_delivery_time_i, ends_at: self.km.max_delivery_time_i, contents: self.km.api_chart_deliveries }
  end
  
  
end
