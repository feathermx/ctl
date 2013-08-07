class Api::City < City
  
  SEARCH_LIMIT = 5
  
  module Json
    List = {
      methods: [:image_path, :last_active_km]
    }
    Filter = {}
  end
  
  scope :list, ->{ select('cities.id, cities.country_id, cities.name, cities.population, cities.population_density, cities.area, cities.big_mac_index').filter_active.ascending }
  scope :filter_base, ->{ select('cities.id, cities.name') }
  scope :search_term, ->(term){ where('cities.name ~* ?', term) }
  
  def self.json_display
    @@json_display ||= Json::List
  end
  
  def self.json_display=(val)
    @@json_display = val
  end
  
  def self.search(q, km_id)
    results = []
    unless q.blank?
      results = self.list.limit(SEARCH_LIMIT)
      q = q.gsub(/\s+/,"").strip
      q.split(' ').each do |term|
        results = results.search_term(term)
      end
    end
    results
  end
  
  def last_active_km
    @last_active_km ||= ->{
      Api::Km.list_base.filter_active.filter_by_city(self.id).descending.first
    }.call
  end
  
  def active_kms_filter
    @active_kms_filter ||= Api::Km.filter_base.filter_active.filter_by_city(self.id).ascending
  end
  
  def as_json(opts = {})
    super(opts.merge(self.class.json_display))
  end
  
end