class String
  def sanitize
    ActionController::Base.helpers.strip_tags(self)  
  end
end

module XssTerminate
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:xss_terminate)
  end
  
  module ClassMethods
    def xss_terminate(options = {})
      before_validation :sanitize_fields
      class_attribute :xss_terminate_options
      self.xss_terminate_options = { except: (options[:except] || []) }
      include XssTerminate::InstanceMethods
    end
  end
  
  module InstanceMethods
    def sanitize_fields
      return if xss_terminate_options.nil?
      self.class.columns.each do |column|
        next unless (column.type == :string || column.type == :text)
        field = column.name.to_sym
        value = self[field]
        next if value.nil?
        if xss_terminate_options[:except].include?(field)
          next
        end
        self[field] = value.sanitize 
      end
    end
  end
  
end
ActiveRecord::Base.send(:include, XssTerminate)