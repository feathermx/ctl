class FrontController < ApplicationController
  
  layout false
  
  protected
  
  def page_elements
    self.title
    self.description
  end
  
  def title
    @title ||= I18n.t('app.title')
  end
  
  def description
    @description ||= I18n.t('app.description')
  end
  
  
end