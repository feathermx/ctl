class KmsController < FrontController
  
  before_filter :assert_ajax_post
  
  def index
    
  end
  
  def show
    render text: '//TODO'
  end
  
  
end
