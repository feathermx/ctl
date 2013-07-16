class Admin::StatsController < Admin::AdminController
  
  before_filter :assert_ajax_protected, except: [:action, :form_action]
  before_filter :assert_list, only: [:index, :list]
  before_filter :assert_edit, only: [:edit, :update]
  before_filter :section
  
  def index
    self.index_section
  end
  
  def action
    
  end
  
  def list
    contents = Admin::Km.stats_list.apply_limit_order(params, SHOW)
    num = Admin::Km.base_count
    render json: {
      total: num[0][:num],
      show: SHOW,
      contents: contents
    }
  end
  
  def form
    render_error and return
  end
  
  def edit
    @element = Admin::Km.find_by_id(params[:id])
    unless @element.nil?
      render :form
    end
  end
  
  def update
    element = Admin::Km.find_by_id(params[:id])
    unless element.nil?
      element.is_active = params[:is_active]
      element.save
      render json: { errors: element.errors }
    end
  end
  
  def delete
    element = Admin::Km.find_by_id(params[:id])
    unless element.nil?
      render json: { deleted: element.destroy }
    end
  end
  
  
  protected
  
  def perm
    @perm ||= User::Perm::Stats
  end
  
  def index_section
    @section.merge!(
      lang_key: 'app.admin.views.stats.title'
    )
  end
  
  def section
    @section = {
      namespace: 'km'
    }
  end
  
  
  
  
end
