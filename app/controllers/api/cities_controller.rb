class Api::CitiesController < Api::ApiController
  
  include Api::Cityable
  
  before_filter :assert_post
  before_filter :assert_city, only: [:list_kms]
  
  # POST /api/cities/list
  def list
    render json: { contents: Api::City.list.as_json(Api::City::Json::List) }
  end
  
  # POST /api/cities/list_kms
  def list_kms
    render json: { contents: self.city.active_kms_filter }
  end
  
  
end