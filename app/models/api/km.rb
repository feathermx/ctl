class Api::Km < Km
  
  module Json
    Default = {}
    List = {
      only: [:id],
      methods: [:full_slug]
    }
    Show = {
      only: [:id, :name, :shops_count, :public_meter_length, :dedicated_meter_length, :peak_deliveries, :peak_disruptions, :peak_traffic, :lat, :lng, :street_lat, :street_lng],
      methods: [:full_name, :utc_offset]
    }
  end
  
  scope :filter_base, ->{ select('kms.id, kms.name') }
  scope :api_base, ->{ select('kms.id, kms.city_id, kms.name, kms.shops_count, kms.public_meter_length, kms.dedicated_meter_length, kms.peak_deliveries, kms.peak_disruptions, kms.peak_traffic, kms.lat, kms.lng, kms.street_lat, kms.street_lng').with_city }
  scope :list_base, ->{ select('kms.id, kms.slug').with_city.with_city_slug.with_country }
  scope :with_city_slug, ->{ select('cities.slug as city_slug') }
  scope :with_city, ->{ select('cities.name as city_name').joins('JOIN cities ON cities.id = kms.city_id') }
  scope :with_country, ->{ select('countries.name as country_name, countries.slug as country_slug').joins("JOIN countries ON countries.id = cities.country_id") }
  
  def self.json_display
    @@json_display ||= Json::Default
  end
  
  def self.json_display=(val)
    @@json_display = val
  end
  
  def as_json(opts = {})
    super(opts.merge(self.class.json_display))
  end
  
  def self.find_api_base_by_id(id)
    self.api_base.filter_active.filter_by_id(id).first
  end
  
  def self.find_active_by_id(id)
    self.base.filter_active.filter_by_id(id).first
  end
  
  def full_slug
    @full_slug ||= "#{self[:country_slug]}/#{self[:city_slug]}/#{self.slug}"
  end
  
  def api_chart_shop_totals
    @api_chart_shop_totals ||= Api::ShopTotal.api_chart_base.filter_by_km(self.id)
  end
  
  def api_map_shops
    @api_map_shops ||= ->{
      list = {}
      Shop::ShopType::List.each do |key, s_type|
        shop_total = Api::ShopTotal.find_by_km_shop_type(self.id, key)
        unless shop_total.nil? || shop_total.total.to_i <= 0
          el = {
            name: s_type[:name],
            elements: Api::Shop.map_data(self.id, key)
          }
          list[key] = el
        end
      end
      list
    }.call
  end
  
  def api_chart_streets
    @api_chart_streets ||= Api::Street.api_chart_base.filter_by_km(self.id)
  end
  
  def api_map_streets
    @api_map_streets ||= Api::Street.map_data(self.id)
  end
  
  def api_chart_deliveries
    @api_chart_deliveries ||= Api::Delivery.api_chart_base.filter_by_km(self.id)
  end
  
  def api_map_deliveries
    @api_map_deliveries ||= ->{
      list = {}
      Delivery::DeliveryType::List.each do |key, d_type|
        elements = Api::Delivery.map_data(self.id, key)
        if elements.length > 0
          el = {
            name: d_type[:name],
            elements: elements
          }
          list[key] = el
        end
      end
      list
    }.call
  end
  
  def api_chart_traffic_count_totals
    @api_chart_traffic_count_totals ||= ->{
      el = Api::TrafficCountTotal.find_chart_base_by_km(self.id)
      el.as_chart unless el.nil?
    }.call
  end
  
  def api_chart_disruptions
    @api_chart_disruptions ||= Api::DeliveriesDisruption.api_chart_base.filter_by_km(self.id)
  end
  
  def api_map_disruptions
    @api_map_disruptions ||= ->{
      list = {}
      TrafficDisruption::LengthType::List.each do |key, l_type|
        elements = Api::TrafficDisruption.map_data(self.id, key)
        if elements.length > 0
          el = {
            name: l_type[:name],
            elements: elements
          }
          list[key] = el
        end
      end
      list
    }.call
  end
  
end