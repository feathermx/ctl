module Admin::Kmable
  
  extend ActiveSupport::Concern
  
  included do
    
    def city
      @city ||= self.app_session.city
    end

    def km
      @km ||= self.city.find_km_by_id(params[:km_id]) unless self.city.nil?
    end

    protected
    
    def assert_km
      render_404 if self.km.nil?
    end
    
  end
  
end