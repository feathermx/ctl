class Admin::SharedController < Admin::AdminController
  
  before_filter :assert_post, only: [:upload, :delete_upload]
  before_filter :assert_protected, only: [:delete_upload]
  
  def upload
    render xml: Upload.upload(params[:identity], params[:token], params[:token2], params[:fmx_file])
  end
  
  def delete_upload
    el = Upload.find_token(params[:token], params[:token2])
    el.destroy unless el.nil?
    render text: ''
  end
  
end
