class Admin::Token < Token
  
  def user
    @user ||= Admin::User.find_by_id(self.user_id)
  end
  
  def self.auth_token(user_id)
    el = self.find_by_user(user_id, identity: Identity::Auth)
    if el.nil?
      el = self.generate(user_id, Identity::Auth)
      el = nil unless el.save
    end
    el
  end
  
  def self.find_auth_token(token, secret)
    self.find_token(token, secret, identity: Identity::Auth)
  end
  
end