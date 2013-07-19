module Api::Kmable
  
  extend ActiveSupport::Concern
  
  included do
    
    def assert_km
      self.render_404 if self.km.nil?
    end
    
    def km
      @km ||= Api::Km.find_active_by_id(params[:km_id])
    end
    
  end
  
end