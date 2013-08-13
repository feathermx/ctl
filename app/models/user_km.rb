class UserKm < ActiveRecord::FmxBase
  
  scope :base, ->{ select('user_kms.id, user_kms.user_id, user_kms.km_id') }
  scope :base_count, ->{ select('COUNT(user_kms.id) as num') }
  scope :km_base, ->{ select('kms.id as km_id, kms.name as km_name, cities.name as city_name').joins('JOIN kms ON kms.id = user_kms.km_id').joins('JOIN cities ON cities.id = kms.city_id') }
  scope :filter_by_id, ->(id){ where(id: id) }
  scope :filter_by_user, ->(user_id){ where(user_id: user_id) }
  scope :filter_by_km, ->(km_id){ where(km_id: km_id) }
  
  attr_protected :user_id, :km_id
  
  validates :user_id, :km_id, presence: true
  validates :user_id, numericality: { only_integer: true }
  validates :km_id, numericality: { only_integer: true }, uniqueness: { scope: :user_id }
  
  def self.generate(user_id, km_id)
    el = self.new
    el.user_id, el.km_id = user_id, km_id
    el
  end
  
  def km_full_name
    @km_full_name ||= "#{self[:km_name]}, #{self[:city_name]}"
  end
  
  def user
    @user ||= User.find_by_id(self.user_id)
  end
  
  def km
    @km ||= Km.find_by_id(self.km_id)
  end
  
end