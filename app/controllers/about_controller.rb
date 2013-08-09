class AboutController < FrontController
  
  before_filter :page_elements, only: [:index]
  
  def index
    render layout: 'application'
  end
  
  protected
  
  def title
    @title ||= self.get_title(I18n.t('app.views.about.title'))
  end
  
  
end