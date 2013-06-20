class Admin::LanguagesController < Admin::AdminController
  
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
  
  def list
    contents = Admin::Language.list.apply_limit_order(params, SHOW)
    num = Admin::Language.base_count
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
    @element = Admin::Language.new
    render :form
  end
  
  def create
    element = Admin::Language.new(params[:admin_language])
    element.save
    render json: { errors: element.errors }
  end
  
  def edit
    @element = Admin::Language.find_by_id(params[:id])
    unless @element.nil?
      render :form
    end
  end
  
  def update
    element = Admin::Language.find_by_id(params[:id])
    unless element.nil?
      element.update_attributes(params[:admin_language])
      render json: { errors: element.errors }
    end
  end
  
  def delete
    element = Admin::Language.find_by_id(params[:id])
    unless element.nil?
      render json: { deleted: element.destroy }
    end
  end
  
  protected
  
  def perm
    @perm ||= User::Perm::Languages
  end
  
  def index_section
    @section.merge!(
      lang_key: 'app.admin.views.languages.title'
    )
  end
  
  def section
    @section = {
      namespace: 'language'
    }
  end
  
end