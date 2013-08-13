class Admin::UsersController < Admin::AdminController
  
  before_filter :assert_ajax_protected, except: [:action, :form_action]
  before_filter :assert_list, only: [:index, :list]
  before_filter :assert_add, only: [:new, :create]
  before_filter :assert_edit, only: [:edit, :update]
  before_filter :assert_delete, only: [:delete]
  before_filter :section
  
  def index
    self.index_section
  end
  
  def action
    
  end
  
  def form_action
    @element = ->{
      cls = Admin::User
      params[:id].nil? ? cls.new : cls.find_by_id(params[:id])
    }.call
    render_404 if @element.nil?
  end
  
  def list
    contents = Admin::User.filter(Admin::User.list, self.app_session).apply_limit_order(params, SHOW)
    num = Admin::User.filter(Admin::User.base_count, self.app_session)
    render json: {
      total: num[0][:num],
      show: SHOW,
      contents: contents
    }
  end
  
  def form
    render_error and return
  end
  
  def new
    @element = Admin::User.new
    render :form
  end
  
  def create
    element = Admin::User.new(params[:admin_user])
    element.setting_km = true
    element.set_password(params[:admin_user][:password], params[:admin_user][:password_confirmation])
    element.perms = params[:perms]
    element.save
    render json: { errors: element.errors }
  end
  
  def edit
    @element = Admin::User.admin_find_by_id(params[:id], self.app_session)
    unless @element.nil?
      render :form
    end
  end
  
  def update
    element = Admin::User.admin_find_by_id(params[:id], self.app_session)
    unless element.nil?
      element.setting_km = true
      element.perms = params[:perms]
      element.update_attributes(params[:admin_user])
      render json: { errors: element.errors }
    end
  end
  
  def delete
    element = Admin::User.admin_find_by_id(params[:id], self.app_session)
    unless element.nil?
      render json: { deleted: element.destroy }
    end
  end
  
  protected
  
  def perm
    @perm ||= User::Perm::Users
  end
  
  def index_section
    @section.merge!(
      lang_key: 'app.admin.views.users.title'
    )
  end
  
  def section
    @section = {
      namespace: 'user'
    }
  end
  
end