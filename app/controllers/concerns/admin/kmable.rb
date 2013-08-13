module Admin::Kmable
  
  extend ActiveSupport::Concern
  
  included do

    protected
    
    def km
      @km ||= self.km_by_id(params[:km_id])
    end
    
    def km_base
      @km_base ||= ->{
        base = Admin::Km.where(nil)
        base = base.filter_by_user(self.app_session.id) unless self.app_session.list?(User::Perm::Stats)
        base
      }.call
    end

    def km_by_id(id)
      km = self.km_base.filter_by_id(id).first
      Admin::Km.find_by_id(km.id) unless km.nil?
    end
    
    def assert_km
      render_404 if self.km.nil?
    end
    
  end
  
end