module Permissible
  
  extend ActiveSupport::Concern
  
  included do
    
    attr_accessor :perms
    
    def perms=(val)
      self.reset_perms
      unless val.nil? || !val.kind_of?(Hash)
        self.perm_fields.each do |key|
          field_name = self.perm_field_name(key)
          field_name << "="
          self.send(field_name, self.fetch_perm(key, val[key]))
        end
      end
    end
    
    protected
    
    def fetch_perm(key, list)
      perm = 0
      unless list.nil? || !list.kind_of?(Array)
        list.each do |val|
          val = val.to_i
          perm |= val if self.perm_list.include?(val)
        end
      end
      perm
    end
    
    def reset_perms
      self.perm_fields.each do |key|
        field_name = self.perm_field_name(key)
        field_name << "="
        self.send(field_name, 0)
      end
    end
    
    def perm_field_name(key)
      "#{key}_perms"
    end
    
    def perm_list
      raise NotImplementedError
    end
    
    def perm_fields
      raise NotImplementedError
    end
    
  end
  
  
end