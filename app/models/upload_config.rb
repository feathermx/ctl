class UploadConfig < ActiveRecord::FmxBase
  
  scope :base, ->{ select("upload_configs.id, upload_configs.max_size, upload_configs.identity, upload_configs.allowed_extensions") }
  scope :base_count, ->{ select("COUNT(upload_configs.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  scope :filter_by_identity, ->(identity){ where(identity: identity) }
  
  attr_protected :identity
  
  def self.find_by_identity(identity)
    self.base.filter_by_identity(identity).first
  end
  
  def valid_extension?(extension)
    self.extensions.include?(extension)
  end
  
  def extensions
    @extensions ||= self.allowed_extensions.split(",")
  end
  
end