class KmsController < FrontController
  
  alias :base_title :title
  alias :base_description :description
  
  before_filter :assert_ajax_post, only: [:index]
  before_filter :assert_km, only: [:show, :show_action]
  before_filter :page_elements, only: [:show]
  
  def index
    
  end
  
  def show
    render layout: 'application'
  end
  
  def show_action
    Api::Km.json_display = Api::Km::Json::List
  end
  
  protected
  
  def title
    @title ||= "#{self.base_title} | #{@km.full_name}"
  end
  
  def description
    @description ||= ->{
      description = self.base_description
      description = self.km.description unless self.km.description.blank?
      description
    }.call
  end
  
  def assert_km
    render_404 if self.km.nil?
  end
  
  def km
    @km ||= Api::Km.find_by_full_slug(params[:country], params[:city], params[:km])
  end
  
  
end
