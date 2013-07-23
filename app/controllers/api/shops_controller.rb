class Api::ShopsController < Api::ApiController
  
  include Api::Kmable
  
  before_filter :assert_km, only: [:chart, :map]
  
  # POST /api/shops/chart
  def chart
    Api::ShopTotal.json_display = Api::ShopTotal::Json::Chart
    render json: { contents: self.km.api_chart_shop_totals }
  end
  
  # POST /api/shops/map
  def map
    Api::Shop.json_display = Api::Shop::Json::Map
    render json: { contents: self.km.api_map_shops }
  end
  
  
end