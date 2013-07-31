module Backup
  
  class Backup
    
    IgnoreFiles = %w{. ..}
    
    def config
      @config ||= Settings.get('backup')
    end
    
    def dir
      @dir ||= "#{Rails.root.to_s}/#{self.config["dir"]}"
    end
    
    def file_format
      @file_format ||= self.config["file_format"]
    end
    
  end
  
end