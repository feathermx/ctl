class Admin::UploadConfig < UploadConfig
  
  module Identity
    CountryImage = 'country_image'
    
    def self.find(key)
      el = nil
      begin
        el = self.module_eval(key.to_s)
      end
      el
    end
    
  end
  
  def as_json(opts={})
    super(opts.merge(root: false))
  end
  
end