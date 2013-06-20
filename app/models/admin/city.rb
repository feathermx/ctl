class Admin::City < City
  
  scope :list, ->{ select("cities.id, cities.name") }
  
  def self.select_list
    self.list.with_country.ascending.map do |el|
      ["#{el.name}, #{el[:country_name]}", el.id]
    end
  end
  
  def list_elements(base)
    base.filter_by_city(self.id)
  end
  
  def find_km_by_id(id)
    Admin::Km.base.filter_by_city(self.id).filter_by_id(id).first
  end
  
  
end