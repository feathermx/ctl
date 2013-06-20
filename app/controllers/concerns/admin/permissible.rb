module Admin::Permissible
  
  extend ActiveSupport::Concern
  
  included do
    
    helper_method :list?, :add?, :edit?, :delete?
    
    protected
    
    def list?(opts = {})
      opts = self.perm_opts(opts)
      opts[:user].list?(opts[:perm])
    end
    
    def add?(opts = {})
      opts = self.perm_opts(opts)
      opts[:user].add?(opts[:perm])
    end
    
    def edit?(opts = {})
      opts = self.perm_opts(opts)
      opts[:user].edit?(opts[:perm])
    end
    
    def delete?(opts = {})
      opts = self.perm_opts(opts)
      opts[:user].delete?(opts[:perm])
    end
    
    def perm
      raise NotImplementedError
    end
    
    def perm_opts(opts)
      { user: self.app_session, perm: self.perm }.merge(opts)
    end
    
    def assert_list
      if self.app_session.nil? || !self.list?
        render_403 and return false
      end
    end
    
    def assert_add
      if self.app_session.nil? || !self.add?
        render_403 and return false
      end
    end
    
    def assert_edit
      if self.app_session.nil? || !self.edit?
        render_403 and return false
      end
    end
    
    def assert_delete
      if self.app_session.nil? || !self.delete?
        render_403 and return false
      end
    end
    
  end
  
  
end