
class Admin::MyController < Admin::AdminController
  
  before_filter :assert_ajax_protected, except: [:profile_action, :info_action, :password_action, :city_action]
  before_filter :section
  
  def profile
    @profile_menu = self.class.profile_menu
    self.index_section
  end
  
  def profile_action
    
  end
  
  def info
    @element = Admin::User.find_by_id(self.app_session.id)
    render_404 if @element.nil?
  end
  
  def info_action
    
  end
  
  def update_info
    element = Admin::User.find_by_id(self.app_session.id)
    unless element.nil?
      element.update_attributes(params[:admin_user])
      render json: { errors: element.errors }
    end
  end
  
  def password
    @element = Admin::User.new
  end
  
  def password_action
    
  end
  
  def update_password
    element = Admin::User.find_by_id(self.app_session.id)
    unless element.nil?
      data = params[:admin_user] || {}
      element.set_password(data[:password], data[:password_confirmation], data[:old_password])
      element.save
      render json: { errors: element.errors }
    end
  end
  
  def city
    @element = Admin::User.find_by_id(self.app_session.id)
  end
  
  def city_action
    @element = self.app_session.city
    render_404 if @element.nil?
  end
    
  def update_city
    element = self.app_session.city
    unless element.nil?
      element.update_attributes(params[:admin_city])
      render json: { errors: element.errors }
    end
  end
  
  protected
  
  def section
    @section = {}
  end
  
  def index_section
    @section.merge!(
      lang_key: 'app.admin.views.profile.title',
      show_add_btn: false
    )
  end
  
  def self.profile_menu
    @@profile_menu ||= [
      {
        key: 'info',
        url: { controller: :my, action: :info }
      },
      {
        key: 'password',
        url: { controller: :my, action: :password }
      },
      {
        key: 'city',
        url: { controller: :my, action: :city }
      }
    ]
  end
  
  
  
end
