class Admin::TracksController < Admin::AdminController
  
  include Admin::Kmable
  
  before_filter :assert_ajax_protected, except: [:action, :new_action]
  before_filter :assert_edit, only: [:index, :list, :new, :create, :delete]
  before_filter :assert_km
  before_filter :section
  
  def index
    self.index_section
  end
  
  def action
    
  end
  
  def list
    contents = self.km.list_elements(Admin::Track.list.apply_limit_order(params))
    render json: {
      total: self.km.track_count,
      show: self.km.track_count,
      contents: contents
    }
  end
  
  def new
    self.new_section
  end
  
  def create
    render json: { errors: Admin::Track.mass_insert(params[:tracks], { km_id: self.km.id }) }
  end
  
  def delete
    element = self.km.find_track_by_id(params[:id])
    unless element.nil?
      render json: { deleted: element.destroy }
    end
  end
  
  protected
  
  def perm
    @perm ||= User::Perm::Kms
  end
  
  def index_section
    @section.merge!(
      lang_key: 'app.admin.views.tracks.title',
      lang_args: {
        km: self.km.name
      },
      table_wrapper_cls: 'half'
    )
  end
  
  def new_section
    @section.merge!(
      lang_key: 'app.admin.views.tracks.new.title'
    )
  end
  
  def section
    @section = {
      namespace: 'track',
      is_subsection: true,
      params: {
        km_id: self.km.id
      }
    }
  end
  
end