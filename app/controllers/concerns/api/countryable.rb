module Api::Countryable
  
  extend ActiveSupport::Concern
  
  included do
    
    def assert_country
      self.render_404 if self.country.nil?
    end
    
    def country
      @country ||= Api::Country.find_active_by_id(params[:country_id])
    end
    
  end
  
  
end