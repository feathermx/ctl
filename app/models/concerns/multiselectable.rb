module Multiselectable
  
  extend ActiveSupport::Concern
  
  class MultiSelectField
    
    attr_accessor :name, :model, :list_with, :parent
    
    def initialize(args = {})
      args.each do |name, value|
        send("#{name}=", value)
      end
    end
    
    def self.generate(args)
      self.new(args)
    end
    
    def parent=(val)
      @parent = val
      self.set_parent
    end
    
    def list_name
      @list_name ||= "#{self.name}_list"
    end
    
    def setting_name
      @setting_name ||= "setting_#{self.name}"
    end
    
    def db_list
      @db_list ||= self.parent.send(self.list_with)
    end
    
    def list
      @list ||= self.parent.send(self.list_name)
    end
    
    def setting
      @setting ||= self.parent.send(self.setting_name)
    end
    
    def setting=(val)
      self.parent.send("#{self.setting_name}=", val)
      @setting = nil
    end
    
    def set_parent
      self.parent.class_eval("attr_accessor :#{self.list_name}")
      self.parent.class_eval("attr_accessor :#{self.setting_name}")
    end
    
    def save
      if self.setting
        self.setting = false
        self.destroy
        unless self.list.blank? || !self.list.kind_of?(Array)
          self.list.each do |el_id|
            el = self.model.generate(self.parent.id, el_id)
            el.save
          end
        end
      end
    end
    
    def destroy
      self.db_list.each do |el|
        el.destroy
      end
    end
    
  end
  
  included do
    after_initialize :set_multiselect_fields
    after_save :save_multiselects
    before_destroy :destroy_multiselects
  end
  
  def initialize(attributes = {})
    self.set_multiselect_fields
    super
  end
  
  protected
  
  #required
  def multiselect_fields
    raise NotImplementedError
  end
  
  def save_multiselects
    self.multiselect_fields.each do |el|
      el.save
    end
  end
  
  def destroy_multiselects
    self.multiselect_fields.each do |el|
      el.destroy
    end
  end
  
  def set_multiselect_fields
    if @set_multiselect_fields.nil?
      @set_multiselect_fields = true
      self.multiselect_fields.each do |el|
        el.parent = self
      end
    end
  end
  
  
end