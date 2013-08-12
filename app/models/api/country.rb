class Api::Country < Country
  
  module Json
    Default = {}
    List = {}
    Map = {
      only: [:id, :name, :slug],
      methods: [:map_cities]
    }
  end
  
  scope :list, ->{ select('DISTINCT(countries.id), countries.name').with_cities.filter_active_cities.ascending }
  scope :api_base, ->{ base.with_cities.filter_active_cities }
  scope :api_map_base, ->{ select('DISTINCT(countries.id), countries.name, countries.slug') }
  
  def self.json_display
    @@json_display ||= Json::Default
  end
  
  def self.json_display=(val)
    @@json_display = val
  end
  
  def as_json(opts = {})
    super(opts.merge(self.class.json_display))
  end
  
  def self.map_list
    Api::City.json_display = Api::City::Json::Map
    self.api_map_base
  end
  
  def map_cities
    @map_cities ||= Api::City.map_base.filter_active.filter_by_country(self.id)
  end
  
  def active_cities_filter
    @active_cities_filter ||= Api::City.filter_base.filter_active.filter_by_country(self.id).ascending
  end
  
  def self.find_active_by_id(id)
    self.api_base.with_cities.filter_active_cities.filter_by_id(id).first
  end
  
end