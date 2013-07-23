class Api::TrafficCountsController < Api::ApiController
  
  include Api::Kmable
  
  before_filter :assert_km, only: [:chart]
  
  # POST /api/traffic_counts/chart
  def chart
    render json: { contents: self.km.api_chart_traffic_count_totals }
  end
  
end