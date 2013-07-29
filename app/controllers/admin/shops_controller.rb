class Admin::ShopsController < Admin::AdminController
  
  include Admin::Kmable
  
  before_filter :assert_ajax_protected, except: [:action, :new_action]
  before_filter :assert_edit, only: [:index, :list, :new, :create, :delete, :delete_all]
  before_filter :assert_km
  before_filter :section
  
  def index
    self.index_section
  end
  
  def action
    
  end
  
  def list
    contents = self.km.list_elements(Admin::Shop.list.apply_limit_order(params, SHOW))
    num = self.km.list_elements(Admin::Shop.base_count)
    render json: {
      total: num[0][:num],
      show: SHOW,
      contents: contents
    }
  end
  
  def new
    self.new_section
  end
  
  def create
    render json: { errors: Admin::Shop.mass_insert(params[:csv_data], { km_id: self.km.id }) }
  end
  
  def delete
    element = self.km.find_shop_by_id(params[:id])
    unless element.nil?
      render json: { deleted: element.destroy }
    end
  end
  
  def delete_all
    self.km.destroy_shops
    render json: { deleted: self.km.save }
  end
  
  protected
  
  def perm
    @perm ||= User::Perm::Kms
  end
  
  def index_section
    @section.merge!(
      lang_key: 'app.admin.views.shops.title',
      lang_args: {
        km: self.km.name
      }
    )
  end
  
  def new_section
    @section.merge!(
      lang_key: 'app.admin.views.shops.new.title'
    )
  end
  
  def section
    @section = {
      namespace: 'shop',
      js_parent: 'app.dashboard.km',
      is_subsection: true,
      params: {
        km_id: self.km.id
      }
    }
  end
  
end