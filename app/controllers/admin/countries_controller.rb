class Admin::CountriesController < Admin::AdminController
  
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
    contents = Admin::Country.list.apply_limit_order(params, SHOW)
    num = Admin::Country.base_count
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
    self.upload_opts
  end
  
  def new
    @element = Admin::Country.new
    render :form
  end
  
  def create
    element = Admin::Country.new(params[:admin_country])
    element.save
    render json: { errors: element.errors }
  end
  
  def edit
    @element = Admin::Country.find_by_id(params[:id])
    unless @element.nil?
      render :form
    end
  end
  
  def update
    element = Admin::Country.find_by_id(params[:id])
    unless element.nil?
      element.update_attributes(params[:admin_country])
      render json: { errors: element.errors }
    end
  end
  
  def delete
    element = Admin::Country.find_by_id(params[:id])
    unless element.nil?
      render json: { deleted: element.destroy }
    end
  end
  
  protected
  
  def perm
    @perm ||= User::Perm::Countries
  end
  
  def index_section
    @section.merge!(
      lang_key: 'app.admin.views.countries.title'
    )
  end
  
  def section
    @section = {
      namespace: 'country'
    }
  end
  
end
