module Api::Cityable
  
  extend ActiveSupport::Concern
  
  included do
    
    def assert_city
      self.render_404 if self.city.nil?
    end
    
    def city
      @city ||= Api::City.find_active_by_id(params[:city_id])
    end
    
    
  end
  
  
end