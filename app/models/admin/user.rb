class Admin::User < User
  
  scope :list, ->{ select("users.id, users.city_id, users.name, users.last_names, users.mail").with_city.with_country }
  scope :exclude, ->(id){ where.not(id: id) }
  
  def as_json(opts)
    super(opts.merge(
      methods: [:city_full_name]
    ))
  end
  
  def city
    @city ||= Admin::City.find_by_id(self.city_id)
  end
  
  def city_full_name
    @city_full_name ||= ->{
      "#{self[:city_name]}, #{self[:country_name]}" unless self[:city_name].nil?
    }.call
  end
  
  def auth_token
    @auth_token ||= Admin::Token.auth_token(self.id)
  end
  
  def self.admin_find_by_id(id, user)
    base = self.base
    self.filter(base, user).filter_by_id(id).first
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