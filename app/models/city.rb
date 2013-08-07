class City < ActiveRecord::FmxBase
  
  include Slugable
  
  scope :base, ->{ select("cities.id, cities.active_count, cities.country_id, cities.language_id, cities.name, cities.slug, cities.city_time_zone, cities.population, cities.population_density, cities.area, cities.us_exchange_rate, cities.gdp, cities.big_mac_index, cities.lat, cities.lng") }
  scope :base_count, ->{ select("COUNT(cities.id) as num") }
  scope :with_country, ->{ select("countries.id as country_id, countries.name as country_name").joins("JOIN countries ON countries.id = cities.country_id") }
  scope :filter_by_country, ->(country_id){ where(country_id: country_id) }
  scope :filter_by_id, ->(id){ where(id: id) }
  scope :filter_active, ->{ where('cities.active_count > 0') }
  scope :ascending, ->{ order("cities.name ASC") }
  
  attr_protected :country_id
  
  validates :country_id, :name, :city_time_zone, :lat, :lng, presence: true
  validates :name, length: { in: 2..100 }
  validates :population, numericality: { only_integer: true }, allow_nil: true
  validates :population_density, numericality: true, allow_nil: true
  validates :area, numericality: true, allow_nil: true
  validates :us_exchange_rate, numericality: true, allow_nil: true
  validates :gdp, numericality: true, allow_nil: true
  validates :big_mac_index, numericality: true, allow_nil: true
  validates :lat, numericality: true
  validates :lng, numericality: true
  validates :slug, uniqueness: { scope: :country_id }, allow_nil: true
  
  after_create :add_country_count
  before_destroy :substract_country_count
  
  def self.find_active_by_id(id)
    self.base.filter_active.filter_by_id(id).first
  end
  
  def last_active_km_id
    @last_active_km_id ||= ->{
      el = Km.base_id.filter_active.filter_by_city(self.id).descending.first
      el.id unless el.nil?
    }.call
  end
  
  def image_path
    @image_path ||= self.country.image_path
  end
  
  def time_zone
    @time_zone ||= ActiveSupport::TimeZone.new self.city_time_zone
  end
  
  def language_id=(val)
    write_attribute(:language_id, val) unless val.blank?
  end
  
  def country
    @country ||= Country.find_by_id(self.country_id)
  end
  
  protected
  
  def add_country_count
    self.country.city_count = self.country.city_count.to_i + 1
    self.country.save
  end
  
  def substract_country_count
    self.country.city_count = self.country.city_count - 1
    self.country.save
  end
  
end