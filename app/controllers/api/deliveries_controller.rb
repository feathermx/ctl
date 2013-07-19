class Api::DeliveriesController < Api::ApiController
  
  include Api::Kmable
  
  before_filter :assert_km, only: [:chart]
  
  # POST /api/deliveries/chart
  def chart
    Api::DeliveriesDisruption.json_display = Api::DeliveriesDisruption::Json::DeliveriesChart
    render json: { contents: self.km.api_chart_deliveries }
  end
  
  
end
