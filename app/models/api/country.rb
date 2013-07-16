class Api::Country < Country
  
  scope :list, ->{ select('DISTINCT(countries.id), countries.name').with_cities.filter_active_cities.ascending }
  scope :api_base, ->{ base.with_cities.filter_active_cities }
  
  def active_cities_filter
    @active_cities_filter ||= Api::City.filter_active.filter_base.filter_by_country(self.id).ascending
  end
  
  def self.find_active_by_id(id)
    self.api_base.with_cities.filter_active_cities.filter_by_id(id).first
  end
  
end