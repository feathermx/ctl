class Admin::TrafficCountsController < Admin::AdminController
  
  include Admin::Kmable
  
  before_filter :assert_ajax_protected, except: [:action, :new_action]
  before_filter :assert_edit, only: [:index, :list, :new, :create, :delete]
  before_filter :assert_km
  before_filter :section
  
  protected
  
  def perm
    @perm ||= User::Perm::Kms
  end
  
  def index_section
    @section.merge!(
      lang_key: 'app.admin.views.traffic_counts.title',
      lang_args: {
        km: self.km.name
      }
    )
  end
  
  def new_section
    @section.merge!(
      lang_key: 'app.admin.views.traffic_counts.new.title'
    )
  end
  
  def section
    @section = {
      namespace: 'traffic_count',
      is_subsection: true,
      params: {
        km_id: self.km.id
      }
    }
  end
  
  
  
end
