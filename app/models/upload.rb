class Upload < ActiveRecord::FmxBase
  
  include Tokenable
  
  scope :base, -> { select("uploads.id, uploads.upload_config_id, uploads.user_id, uploads.token, uploads.secret, uploads.extension, uploads.expires_at") }
  scope :base_count, -> { select("COUNT(uploads.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  
  attr_protected :upload_config_id, :user_id, :extension
  attr_accessor :file
  
  validates :upload_config_id, :expires_at, presence: true
  validates :upload_config_id, numericality: true
  validate :validate_file
  
  after_save :on_after_save
  before_destroy :on_before_destroy
  
  def validate_file
    errors.add(:file, I18n.t('activerecord.errors.messages.empty')) if self.new_record? && self.file.blank?
  end
  
  def self.expiry
    Time.now.advance(days: 1)
  end
  
  def self.generate(user_id, upload_config_id, extension, file)
    self.generate_token(user_id, { 
      expires_at: self.expiry, 
      upload_config_id: upload_config_id, 
      extension: extension, 
      file: file
    })
  end
  
  def self.upload(identity, token, secret, file)
    result = { status: false, token: token, token2: secret }
    el = self.new
    uc = nil
    uc = UploadConfig.find_by_identity(identity) unless file.nil?
    token = Token.find_token(token, secret, identity: Token::Identity::Auth) unless uc.nil?
    unless token.nil?
      ext = file.original_filename.split('.').last
      ext.downcase! unless ext.nil?
      unless ext.blank? || file.tempfile.size > uc.max_size.to_i || !uc.valid_extension?(ext)
        upload = self.generate(token.user.id, uc.id, ext, file)
        if upload.save
          result.merge!(status: true, token: upload.token, token2: upload.secret)
        end
      end
    end
    result
  end
  
  def abs_path
    @abs_path ||= Rails.root.join(Settings.get('paths.upload'), self.file_name).to_s
  end
  
  def move(path)
    File.unlink(path) if File.exist?(path)
    File.rename(self.abs_path, path)
    self.destroy
  end
  
  protected
  
  def file_name
    puts self.inspect
    @file_name ||= "#{self.token}_#{self.secret}"
  end
  
  def on_after_save
    self.save_file
  end
  
  def on_before_destroy
    self.destroy_file
  end
  
  def save_file
    unless self.file.nil?
      File.open(self.abs_path, 'wb') do |f|
        f.write(self.file.read)
      end
    end
  end
  
  def destroy_file
    File.unlink(self.abs_path) if File.exist?(self.abs_path)
  end
  
end