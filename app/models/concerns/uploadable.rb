module Uploadable
  
  extend ActiveSupport::Concern
  
  class UploadField
    
    attr_accessor :index, :name, :ext_field, :required, :parent, :thumb
    
    def initialize(args = {})
      args.each do |name, value|
        send("#{name}=", value)
      end
    end
    
    def has_thumb?
      @has_thumb ||= !(self.thumb.nil?)
    end
    
    def thumb_dimensions
      if @thumb_dimensions.nil?
        @thumb_dimensions = "#{self.thumb[:width]}x#{self.thumb[:height]}"
      end
      @thumb_dimensions
    end
    
    def upload_name
      @upload_name ||= "#{self.name}_upload"
    end
    
    def self.generate(args)
      #name: name, ext_field: ext_field, required: required
      self.new(args)
    end
    
    def extension
      @extension ||= self.parent[self.ext_field]
    end
    
    def extension=(val)
      @extension = self.parent[self.ext_field] = val
    end
    
    def file_name
      @file_name ||= self.parent.file_name
    end
    
    def url
      @url ||= "#{self.url_base}/#{self.file_name_with_extension}"
    end
    
    def thumb_url
      @thumb_url ||= "#{self.thumb_url_base}/#{self.file_name_with_extension}"
    end
    
    def abs_path
      @abs_path ||= "#{self.parent.abs_path}/#{self.name}/#{self.file_name_with_extension}"
    end
    
    def thumb_abs_path
      @thumb_abs_path ||= "#{self.parent.abs_path}/#{self.name}_thumb/#{self.file_name_with_extension}"
    end
    
    def thumb_url_base
      @thumb_url_base ||= "#{self.parent.upload_dir}/#{self.name}_thumb"
    end
    
    def url_base
      @url_base ||= "#{self.parent.upload_dir}/#{self.name}"
    end
    
    def file_name_with_extension
      @file_name_with_extension ||= "#{self.file_name}.#{self.extension}"
    end
    
    def before_save
      unless self.upload.nil?
        self.destroy
        self.extension = self.upload.extension
      end
    end
    
    def save
      unless self.upload.nil?
        @file_name_with_extension = @file_name = @url = @thumb_url = @abs_path = @thumb_abs_path = nil
        self.parent.reset_uploads
        self.upload.move(self.abs_path)
        self.create_thumb
        @upload = nil
      end
    end
    
    def create_thumb
      if self.has_thumb? && File.exist?(self.abs_path)
        file = File.open(self.abs_path)
        tmb = MiniMagick::Image.read(file)
        tmb.resize self.thumb_dimensions
        tmb.write self.thumb_abs_path
        file.close
      end
    end
    
    def destroy_thumb
      if self.has_thumb?
        File.unlink(self.thumb_abs_path) if File.exist?(self.thumb_abs_path)
      end
    end
    
    def destroy
      File.unlink(self.abs_path) if File.exist?(self.abs_path)
      self.destroy_thumb
    end
    
    def validate
      if self.parent.new_record? && self.required
        self.parent.errors.add(self.upload_name, I18n.t('activerecord.errors.messages.empty')) if self.upload.nil?
      end
    end
    
    def upload_field_name
      @upload_field_name ||= "#{self.name}_upload"
    end
    
    def upload
      @upload ||= self.parent.send(self.upload_field_name)
    end
    
    def set_parent
      self.set_image
      self.set_thumb
    end
    
    def set_image
      image_url_method = "#{self.name}_url"
      abs_path_method = "#{self.name}_abs_path"
      upload_field_name_setter = "#{self.upload_field_name}="
      obj = self
      self.parent.class_eval("attr_accessor :#{self.upload_field_name}")
      self.parent.class.send :define_method, image_url_method.to_sym do
        self.upload_fields[obj.index].url
      end
      self.parent.class.send :define_method, abs_path_method.to_sym do
        self.upload_fields[obj.index].abs_path
      end
      self.parent.class_eval("def #{self.upload_field_name}=(val);@#{self.upload_field_name}=self.first_upload_val(val);end")
    end
    
    def set_thumb
      if self.has_thumb?
        image_url_method = "#{self.name}_thumb_url"
        abs_path_method = "#{self.name}_thumb_abs_path"
        obj = self
        self.parent.class.send :define_method, image_url_method.to_sym do
          self.upload_fields[obj.index].thumb_url
        end
        self.parent.class.send :define_method, abs_path_method.to_sym do
          self.upload_fields[obj.index].thumb_abs_path
        end
      end
    end
    
    def parent=(val)
      @parent = val
      self.set_parent
    end
    
  end
  
  included do
    attr_accessor :upload_fields
    validate :validate_uploads
    after_initialize :set_upload_fields
    before_save :set_uploads
    after_save :save_files
    before_destroy :destroy_files
  end
  
  def initialize(attributes = {})
    self.set_upload_fields
    super
  end
  
  def reset_uploads
    @file_name = nil
  end
  
  def file_name
    @file_name = "#{self.id}_#{ApplicationController.encrypt(self.upload_dir, self.id)}"
  end
  
  def upload_dir
    @upload_dir ||= self.class.name.downcase.split('::').last
  end
  
  def abs_path
    @abs_path ||= "#{Rails.root.to_s}/public/images/#{self.upload_dir}"
  end
  
  def first_upload_val(val)
    upload = nil
    unless val.blank? || !val.kind_of?(Hash)
      val = val.first
      unless val.nil?
        val = val.last
        unless val.nil?
          upload = Upload.find_token(val['token'], val['secret'])
        end
      end
    end
    upload
  end
  
  protected
  
  #required
  def upload_fields
    raise NotImplementedError
  end
  
  def validate_uploads
    self.upload_fields.each do |el|
      el.validate
    end
  end
  
  def set_upload_fields
    if @setted_upload_fields.nil?
      @setted_upload_fields = true
      i = 0
      self.upload_fields.each do |el|
        el.index = i
        el.parent = self
        i = i + 1
      end
    end
  end
  
  def set_uploads
    self.upload_fields.each do |el|
      el.before_save
    end
  end
  
  def save_files
    self.upload_fields.each do |el|
      el.save
    end
  end
  
  def destroy_files
    self.upload_fields.each do |el|
      el.destroy
    end
  end
  
  
end
