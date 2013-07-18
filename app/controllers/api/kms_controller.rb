class Api::KmsController < Api::ApiController
  
  before_filter :assert_post
  
  # POST /api/kms/show
  def show
    Api::Km.json_display = Api::Km::Json::Show
    el = Api::Km.find_api_base_by_id(params[:km_id])
    if el.nil?
      render_404
    else
      render json: { km: el }
    end
  end
  
  
end
