class SplashController < ApplicationController
  
  def index
    redirect_to controller: 'admin/splash', action: 'index'
  end
  
end