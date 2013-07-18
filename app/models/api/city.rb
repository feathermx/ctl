class Api::City < City
  
  module Json
    List = {
      methods: [:image_path, :last_active_km_id]
    }
    Filter = {}
  end
  
  scope :list, ->{ select('cities.id, cities.country_id, cities.name, cities.population, cities.population_density, cities.area, cities.big_mac_index').filter_active.ascending }
  scope :filter_base, ->{ select('cities.id, cities.name') }
  
  def self.json_display
    @@json_display ||= Json::List
  end
  
  def self.json_display=(val)
    @@json_display = val
  end
  
  def active_kms_filter
    @active_kms_filter ||= Api::Km.filter_base.filter_active.filter_by_city(self.id).ascending
  end
  
  def as_json(opts = {})
    super(opts.merge(self.class.json_display))
  end
  
end