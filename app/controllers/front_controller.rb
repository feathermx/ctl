class FrontController < ApplicationController
  
  layout false
  
  protected
  
  def page_elements
    self.title
    self.description
    self.tags
  end
  
  def title
    @title ||= I18n.t('app.title')
  end
  
  def get_title(el)
    "#{self.base_title} | #{el}"
  end
  
  def tags
    @tags ||= I18n.t('app.tags')
  end
  
  def get_description(el)
    el.blank? ? self.base_description : el
  end
  
  def description
    @description ||= I18n.t('app.description')
  end
  
  alias_method :base_title, :title
  alias_method :base_description, :description
  
  
end