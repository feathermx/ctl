module Controllable
  
  extend ActiveSupport::Concern
  
  module ClassMethods
    def encrypt(*args)
      require 'digest/sha1'
      args.push Settings.get("salt")
      Digest::SHA1.hexdigest(args.join)
    end
  end

  protected
  
  def render_js
    render "#{params[:action]}.js" and return
  end
  
  def base_url
    @base_url ||= "#{request.protocol}#{request.host_with_port}"
  end

  def global_var
    @fmx ||= Settings.get
  end

  def no_cache
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def mime_type(path)
    `file -Ib #{path}`.gsub(/\n/,"")
  end

  def encrypt(*args)
    ActionController::FmxBase.encrypt(*args)
  end

  def assert_post
    unless request.post?
      render_403 and return false
    end
  end

  def assert_ajax_post
    if !request.post? || !request.xml_http_request?
      render_403 and return false
    end
  end

  def assert_protected
    if app_session.nil?
      redirect_to login_url and return false
    end
  end

  def assert_ajax_protected
    if app_session.nil? || !request.post? || !request.xml_http_request?
      render_403 and return false
    end
  end

  def is_post
    if request.post?
      yield
    else
      render_403 and return
    end
  end

  def is_ajax_post
    if request.post? && request.xml_http_request?
      yield
    else
      render_403 and return
    end
  end

  def is_flash_post
    if request.post? && request.env['HTTP_USER_AGENT'] =~ /Flash|flash/
      yield
    else
      render_403 and return
    end 
  end

  def render_403
    render_error(:forbidden, "403 Forbidden")
  end

  def render_404
    render_error(:not_found, "404 Not Found")
  end

  def render_error(status, message = nil)
    message = message.nil? ? "Error" : message
    render text: message, status: status
  end

  def mime_type(path)
    `file -Ib #{path}`.gsub(/\n/,"")
  end

  def render_asset(path, content_type = nil)
    asset_path = "#{Rails.root.to_s}#{path}"
    if File.exist?(asset_path)
      content_type = content_type.nil? ? mime_type(asset_path) : content_type
      asset = File.open(asset_path)
      render text: asset.read, content_type: content_type, layout: false
      asset.close
    else
      render_404
    end
  end
  
end