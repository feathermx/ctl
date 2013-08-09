class KmsController < FrontController
  
  before_filter :assert_km, only: [:show, :show_action]
  before_filter :page_elements, only: [:show]
  
  def show
    render layout: 'application'
  end
  
  def show_action
    Api::Km.json_display = Api::Km::Json::List
  end
  
  protected
  
  def title
    @title ||= self.get_title(@km.full_name)
  end
  
  def description
    @description ||= self.get_description(self.km.description)
  end
  
  def assert_km
    render_404 if self.km.nil?
  end
  
  def km
    @km ||= Api::Km.find_by_full_slug(params[:country], params[:city], params[:km])
  end
  
  
end
