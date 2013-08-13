class Admin::User < User
  
  scope :list, ->{ select("users.id, users.name, users.last_names, users.mail") }
  scope :exclude, ->(id){ where.not(id: id) }
  
  def auth_token
    @auth_token ||= Admin::Token.auth_token(self.id)
  end
  
  def self.admin_find_by_id(id, user)
    base = self.base
    self.filter(base, user).filter_by_id(id).first
  end
  
  def km_multiselect_values
    @km_multiselect_values ||= Admin::UserKm.user_multiselect_values(self.id)
  end
  
  def serialize
    @serialize ||= ->{
      token = self.auth_token
      unless token.nil?
        token.serialize
      end
    }.call
  end
  
  def self.filter(base, user)
    base.merge(self.exclude(user.id))
  end
  
end