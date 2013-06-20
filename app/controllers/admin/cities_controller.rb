class Admin::CitiesController < Admin::AdminController
  
  before_filter :assert_ajax_protected, except: [:action, :form_action]
  before_filter :assert_list, only: [:index, :list]
  before_filter :assert_add, only: [:new, :create]
  before_filter :assert_edit, only: [:edit, :update]
  before_filter :assert_delete, only: [:delete]
  before_filter :assert_country
  before_filter :section
  
  def index
    self.index_section
  end
  
  def action
    
  end
  
  def list
    contents = @country.list_elements(Admin::City.list.apply_limit_order(params, SHOW))
    num = @country.list_elements(Admin::City.base_count)
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
    @element = Admin::City.find_by_id(params[:id]) unless new_record
    render_404 if (!new_record && @element.nil?)
  end
  
  def new
    @element = Admin::City.new
    render :form
  end
  
  def create
    element = Admin::City.new(params[:admin_city])
    element.country_id = @country.id
    element.save
    render json: { errors: element.errors }
  end
  
  def edit
    @element = @country.find_city_by_id(params[:id])
    unless @element.nil?
      render :form
    end
  end
  
  def update
    element = @country.find_city_by_id(params[:id])
    unless element.nil?
      element.update_attributes(params[:admin_city])
      render json: { errors: element.errors }
    end
  end
  
  def delete
    element = @country.find_city_by_id(params[:id])
    unless element.nil?
      render json: { deleted: element.destroy }
    end
  end
  
  protected
  
  def assert_country
    @country = Admin::Country.find_by_id(params[:country_id])
    render_404 if @country.nil?
  end
  
  def perm
    @perm ||= User::Perm::Countries
  end
  
  def index_section
    @section.merge!(
      lang_key: 'app.admin.views.cities.title',
      lang_args: { country: @country.name }
    )
  end
  
  def section
    @section = {
      namespace: 'city',
      params: {
        country_id: @country.id
      },
      js_parent: 'app.dashboard.country',
      is_subsection: true
    }
  end
  
end
