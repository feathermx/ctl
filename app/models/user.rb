class User < ActiveRecord::FmxBase
  
  include Permissible
  include Authenticable
  
  module Perm
    Users = 1
    Languages = 2
    Countries = 4
    Kms = 8
    List = {
      Users => {
        key: 'users'
      },
      Languages => {
        key: 'languages'
      },
      Countries => {
        key: 'countries'
      },
      Kms => {
        key: 'kms'
      }
    }
  end
  
  scope :base, ->{ select("users.id, users.name, users.last_names, users.city_id, users.mail, users.password, users.list_perms, users.add_perms, users.edit_perms, users.delete_perms") }
  scope :base_count, ->{ select("COUNT(users.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  scope :with_city, ->{ select("cities.name as city_name").joins("LEFT JOIN cities ON cities.id = users.city_id") }
  scope :with_country, ->{ select.joins("countries.name as country_name").joins("LEFT JOIN countries ON countries.id = cities.country_id") }
  
  validates :city_id, numericality: { only_integer: true }, allow_nil: true
  validates :name, :last_names, :mail, presence: true
  validates :name, length: { in: 2..100 }
  validates :last_names, length: { in: 2..100 }
  validates :mail, length: { in: 2..50 }, uniqueness: true, format: { with: Regex::Mail }
  validates :list_perms, numericality: { only_integer: true }
  validates :add_perms, numericality: { only_integer: true }
  validates :edit_perms, numericality: { only_integer: true }
  validates :delete_perms, numericality: { only_integer: true }
  
  attr_protected :list_perms, :add_perms, :edit_perms, :delete_perms
  
  def city_id=(val)
    write_attribute(:city_id, val) unless val.blank?
  end
  
  def list?(perm)
    self.list_perms = self.list_perms.to_i
    (perm & self.list_perms) == perm
  end
  
  def add?(perm)
    self.add_perms = self.add_perms.to_i
    (perm & self.add_perms) == perm
  end
  
  def edit?(perm)
    self.edit_perms = self.edit_perms.to_i
    (perm & self.edit_perms) == perm
  end
  
  def delete?(perm)
    self.delete_perms = self.delete_perms.to_i
    (perm & self.delete_perms) == perm
  end
  
  protected
  
  def self.all_perms
    perm = 0
    Perm::List.keys.each do |p|
      perm |= p
    end
    perm
  end
  
  def min_pass_length
    @min_pass_length ||= 6
  end
  
  def perm_list
    @perm_list ||= Perm::List.keys
  end
  
  def perm_fields
    @perm_fields ||= [
      "list", "add", "edit", "delete"
    ]
  end
  
end