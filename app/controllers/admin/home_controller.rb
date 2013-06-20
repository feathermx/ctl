class Admin::HomeController < Admin::AdminController
  
  before_filter :assert_ajax_protected, except: [:index]
  before_filter :assert_protected, only: [:index]
  
  def index
    self.page_elements
    render layout: 'admin/admin'
  end
  
  protected
  
  def perm
    @perm ||= 0
  end
  
  def page_elements
    @menu = self.class.menu
  end
  
  def self.menu
    @@menu ||= [
      {
        key: 'users',
        perm: User::Perm::Users,
        url: { controller: :users, action: :index }
      },
      {
        key: 'languages',
        perm: User::Perm::Languages,
        url: { controller: :languages, action: :index }
      },
      {
        key: 'countries',
        perm: User::Perm::Countries,
        url: { controller: :countries, action: :index }
      },
      {
        key: 'kms',
        perm: User::Perm::Kms,
        url: { controller: :kms, action: :index }
      }
    ]
  end
  
end