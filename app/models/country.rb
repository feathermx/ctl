class Country < ActiveRecord::FmxBase
  
  scope :base, ->{ select("countries.id, countries.city_count, countries.name") }
  scope :base_count, ->{ select("COUNT(countries.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  
  attr_protected :city_count
  
  validates :name, presence: true
  validates :name, length: { in: 2..100 }, uniqueness: true
  
  def cities
    @cities ||= City.base.filter_by_country(self.id)
  end
  
  
end