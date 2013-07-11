class Admin::City < City
  
  scope :list, ->{ select("cities.id, cities.name, cities.city_time_zone") }
  
  def self.timezones_select
    @@timezones_select ||= ->{
      list = []
      list = ActiveSupport::TimeZone.all.map do |el|
        el.name
      end
      list.sort!
      list.map do |el|
        [el, el]
      end
    }.call
  end
  
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