class SplashController < FrontController
  
  before_filter :page_elements, only: [:index]
  
  def index
    render layout: 'application'
  end
  
end