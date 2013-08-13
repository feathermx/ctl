class Admin::Km < Km
  
  module Json
    Default = {}
    List = {
      methods: [:full_name]
    }
    Search = {
      only: [:id, :name],
      methods: [:search_full_name]
    }
  end
  
  SEARCH_LIMIT = 10
  
  scope :list, ->{ select("kms.id, kms.tracks_count, kms.traffic_counts_count, kms.traffic_disruptions_count, kms.street_data_count, kms.parking_restrictions_count, kms.shops_count, kms.deliveries_count, kms.name").with_city }
  scope :stats_list, ->{ select('kms.id, kms.name, kms.is_active') }
  scope :filter_base, ->{ select('kms.id, kms.name').with_city }
  scope :search_filter, ->(term) { where("kms.name ~* ? OR cities.name ~* ?", term, term) }
  
  def self.json_display
    @@json_display ||= Json::Default
  end
  
  def self.json_display=(val)
    @@json_display = val
  end
  
  def self.search(q)
    base = self.filter_base.limit(SEARCH_LIMIT)
    base = self.apply_search(base, q)
    base
  end
  
  def search_full_name
    self[:name] << ", #{self[:city_name]}"
  end
  
  def as_json(opts = {})
    super(opts.merge(self.class.json_display))
  end
  
  def list_elements(base)
    base.filter_by_km(self.id)
  end
  
  def find_track_by_id(id)
    Admin::Track.base.filter_by_km(self.id).filter_by_id(id).first
  end
  
  def find_traffic_count_by_id(id)
    Admin::TrafficCount.filter_by_km(self.id).filter_by_id(id).first
  end
  
  def find_traffic_disruption_by_id(id)
    Admin::TrafficDisruption.filter_by_km(self.id).filter_by_id(id).first
  end
  
  def find_street_data_by_id(id)
    Admin::StreetData.filter_by_km(self.id).filter_by_id(id).first
  end
  
  def find_shop_by_id(id)
    Admin::Shop.filter_by_km(self.id).filter_by_id(id).first
  end
  
  def find_delivery_by_id(id)
    Admin::Delivery.filter_by_km(self.id).filter_by_id(id).first
  end
  
  def find_parking_restriction_by_id(id)
    Admin::ParkingRestriction.filter_by_km(self.id).filter_by_id(id).first
  end
  
  protected

  def self.apply_search(query, q)
    unless q.blank?
      q = q.gsub(/\s+/,"").strip
      q.split(" ").each do |term|
        query = query.search_filter(term)
      end
    end
    query
  end
  
  
end
