module Authenticable

  extend ActiveSupport::Concern

  included do
    
    attr_protected :password
    attr_accessor :original_password, :password_confirmation, :updating_password, :curr_password, :old_password
    validate :valid_password_length, if: :updating_password?
    validate :valid_password_confirmation, if: :updating_password?
    validate :valid_old_password
    
  end
  
  module ClassMethods
    
    def authenticate(mail, pwd)
      user = nil
      unless mail.blank? || pwd.blank?
        pwd = ApplicationController.encrypt(pwd)
        user = self.base.where(mail: mail, password: pwd).first
      end
      user
    end
    
    
  end
  
  def set_password(password, password_confirmation, old_password=nil)
    self.updating_password = true
    self.old_password = ApplicationController.encrypt(old_password) unless old_password.nil?
    self.curr_password = self.password
    self.password = ApplicationController.encrypt(password)
    self.password_confirmation = ApplicationController.encrypt(password_confirmation)
    self.original_password = password
  end
  
  protected
  
  def min_pass_length
    raise NotImplementedError
  end
  
  def valid_old_password
    unless self.old_password.nil?
      message = I18n.t("activerecord.errors.messages.invalid")
      errors.add(:old_password, message) if self.curr_password != self.old_password
    end
  end
  
  def valid_password_length
    unless self.original_password.nil?
      message = I18n.t("activerecord.errors.messages.too_short", count: self.min_pass_length)
      errors.add(:password, message) if self.original_password.length < self.min_pass_length
    else
      errors.add(:password, I18n.t("activerecord.errors.messages.blank"))
    end
  end
  
  def valid_password_confirmation
    message = I18n.t("activerecord.errors.messages.confirmation")
    errors.add(:password, message) if self.password != self.password_confirmation
  end
  
  def updating_password?
    !self.updating_password.nil?
  end
  

end