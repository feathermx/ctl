module Admin::AdminHelper
  
  # upload config
  def uc(key)
    el = nil
    identity = Admin::UploadConfig::Identity.find(key)
    el = Admin::UploadConfig.find_by_identity(identity)
    el.to_json.html_safe
  end
  
end