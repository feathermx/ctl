class Admin::SplashController < Admin::AdminController
  
  layout 'admin/splash'
  
  def index
    unless self.app_session.nil?
      redirect_to controller: :home, action: :index and return
    end
  end
  
  def login
    user = Admin::User.authenticate(params[:user][:mail], params[:user][:password])
    unless user.nil?
      self.app_session = user.serialize.to_json.html_safe
    end
    render json: { logged_in: !user.nil? }
  end
  
  def logout
    self.app_session = nil
    redirect_to action: :index
  end
  
  
end
