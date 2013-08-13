class Admin::KmsController < Admin::AdminController

  include Admin::Kmable

  before_filter :assert_ajax_protected, except: [:action, :form_action]
  before_filter :assert_list, only: [:index, :list]
  before_filter :assert_add, only: [:new, :create]
  before_filter :assert_edit, only: [:edit, :update]
  before_filter :assert_delete, only: [:delete]
  before_filter :section
  
  def index
    self.index_section
  end
  
  def search
    Admin::Km.json_display = Admin::Km::Json::Search
    render json: { contents: Admin::Km.search(params[:q]) }
  end
  
  def action
    
  end
  
  def list
    Admin::Km.json_display = Admin::Km::Json::List
    contents = self.km_base.merge(Admin::Km.list.apply_limit_order(params, SHOW))
    num = self.km_base.merge(Admin::Km.base_count)
    render json: {
      total: num[0][:num],
      show: SHOW,
      contents: contents
    }
  end
  
  def form
    render_error and return
  end
  
  def form_action
    new_record = params[:new_record].to_i == 1
    Admin::Km.json_display = Admin::Km::Json::List
    @element = self.km_by_id(params[:id]) unless new_record
    render_404 if (!new_record && @element.nil?)
  end
  
  def new
    @element = Admin::Km.new
    render :form
  end
  
  def create
    element = Admin::Km.new(params[:admin_km])
    Admin::UserKm.generate(self.app_session.id, element.id).save if element.save
    render json: { errors: element.errors }
  end
  
  def edit
    @element = self.km_by_id(params[:id])
    unless @element.nil?
      render :form
    end
  end
  
  def update
    element = self.km_by_id(params[:id])
    unless element.nil?
      element.update_attributes(params[:admin_km])
      render json: { errors: element.errors }
    end
  end
  
  def delete
    element = self.km_by_id(params[:id])
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
      lang_key: 'app.admin.views.kms.title'
    )
  end
  
  def section
    @section = {
      namespace: 'km'
    }
  end

end