class Admin::HelpController < Admin::AdminController
  before_filter :assert_ajax_protected, except: [:profile_action, :info_action, :password_action, :city_action]
  before_filter :section
  
  def index
    self.index_section
  end
  
  protected
  
  def index_section
    @section.merge!(
      lang_key: 'app.admin.views.help.title',
      show_add_btn: false
    )
  end
  
  def section
    @section = {}
  end

end
