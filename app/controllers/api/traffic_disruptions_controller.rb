class Api::TrafficDisruptionsController < Api::ApiController
  
  include Api::Kmable
  
  before_filter :assert_km, only: [:chart]
  
  # POST /api/traffic_disruptions/chart
  def chart
    Api::DeliveriesDisruption.json_display = Api::DeliveriesDisruption::Json::Chart
    render json: { contents: self.km.api_chart_disruptions }
  end
  
end
