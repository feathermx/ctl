class Admin::PerformanceResultsController < Admin::AdminController

  before_filter :assert_ajax_protected, except: [:action, :show_action]
  before_filter :assert_list, only: [:index, :list]
  before_filter :assert_delete, only: [:delete]
  before_filter :section
  before_filter :assert_performance_result, only: [:show, :show_action]

  def index
    self.index_section
  end
  
  def show
    self.performance_section
  end
  
  def show_action
    
  end  
    
  def action
    
  end
  
  def list
    contents = Admin::PerformanceResult.list.apply_limit_order(params, SHOW)
    num = Admin::PerformanceResult.base_count
    render json: {
      total: num[0][:num],
      show: SHOW,
      contents: contents
    }
  end

  def delete
    element = Admin::PerformanceResult.find_by_id(params[:id])
    unless element.nil?
      render json: { deleted: element.destroy }
    end
  end

  protected
  
  def performance_result
    @performance_result ||= Admin::PerformanceResult.find_by_id(params[:performance_result_id])
  end
  
  def assert_performance_result
    render_404 if self.performance_result.nil?
  end
  
  def perm
    @perm ||= User::Perm::PerformanceResults
  end
  
  def index_section
    @section.merge!(
      lang_key: 'app.admin.views.performance_results.title'
    )
  end
  
  def performance_section
    @section.merge!(
      show_add_btn: false,
      show_cancel_btn: true,
      lang_args: {
        km: self.performance_result.km.name
      }
    )
  end
  
  def section
    @section = {
      namespace: 'performance_result'
    }
  end

end
