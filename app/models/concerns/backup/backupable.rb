module Backup::Backupable
  
  extend ActiveSupport::Concern
  
  include ActiveModel::Serializers::JSON
  
  included do
    
    #def attributes=(hash)
    #  hash.each do |key, value|
    #    #instance_variable_set("@#{key}", value)
    #    send("#{key}=", value)
    #  end
    #end

    #def attributes
    #  @attributes ||= instance_values
    #end
    
  end
  
  module ClassMethods
    
    def from_backup(data)
      el = self.new
      data.each do |name, value|
        el.send("#{name}=", value)
      end
      el
    end
    
    def backup_base
      raise NotImplementedError
    end
    
  end
  
  
end