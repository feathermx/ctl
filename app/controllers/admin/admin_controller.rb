class Admin::AdminController < ApplicationController
  
  include Admin::Permissible
  
  SHOW = 10
  
  attr_accessor :app_session
  
  layout false
  
  protected
  
  def session_name
    @session_name ||= Settings.get("session_name")
  end
  
  def app_session
    if @session.nil?
      session_data = session[self.session_name]
      unless session_data.nil?
        found = false
        if session_data.kind_of?(String)
          data = JSON.parse(session_data)
          unless data.nil?
            token = Admin::Token.find_auth_token(data["token"], data["secret"])
            unless token.nil?
              found = true
              token.renew
              @session = token.user
            end
          end
        end
        session[self.session_name] = nil unless found
      end
    end
    @session
  end
  
  def app_session=(val)
    @app_session = session[self.session_name] = val
  end
  
  def upload_opts
    @session = self.app_session
  end
  
  def login_url
    { controller: :splash, action: :index }
  end
  
  
end