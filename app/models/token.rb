class Token < ActiveRecord::FmxBase
  
  include Tokenable
  
  module Identity
    Auth = 0
  end
  
  scope :base, ->{ select("tokens.id, tokens.user_id, tokens.identity, tokens.token, tokens.secret, tokens.expires_at") }
  scope :filter_by_id, ->(id){ where(id: id) }
  
  validates :identity, :expires_at, presence: true
  
  def user
    @user ||= User.find_by_id(self.user_id)
  end
  
  def self.expiry
    Time.now.advance(days: 1)
  end
  
  def self.generate(user_id, identity)
    self.generate_token(user_id, { expires_at: self.expiry, identity: identity })
  end
  
end