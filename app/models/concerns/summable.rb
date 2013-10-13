module Summable
  
  extend ActiveSupport::Concern
  
  class SumField
    
    # optional field_name
    attr_accessor :nspc, :fields, :total_name, :parent
    
    def initialize(args={})
      opts = { total_name: 'total' }
      opts.merge!(args)
      field_name = opts.delete :field_name
      @total_name = field_name unless field_name.blank?
      opts.each do |name, value|
        send("#{name}=", value)
      end
    end
    
    def total_name
      @total_name ||= "#{self.nspc}_#{self.total_name}"
    end
    
    def set_field
      sum = 0.0
      self.fields.each do |f|
        field_name = "#{f}_#{self.nspc}"
        sum = sum + self.parent.send(field_name).to_f
      end
      self.parent.send("#{self.total_name}=", sum)
    end
    
    def before_save
      self.set_field
    end
    
  end
  
  included do
    
    after_initialize :set_summable_fields
    before_save :summable_fields_before_save
    
    protected
    
    # required
    def summable_fields
      raise NotImplementedError
    end
    
    def set_summable_fields
      if @setted_summable_fields.nil?
        @setted_summable_fields = true
        self.summable_fields.each do |el|
          el.parent = self
        end
      end
    end
    
    def summable_fields_before_save
      self.summable_fields.each do |el|
        el.before_save
      end
    end
    
    
  end
  
  
end