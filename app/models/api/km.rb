class Api::Km < Km
  
  module Json
    Default = {}
    Show = {
      only: [:id, :name, :shops_count, :public_meter_length, :dedicated_meter_length, :peak_deliveries, :peak_disruptions, :peak_traffic, :lat, :lng, :street_lat, :street_lng],
      methods: [:full_name, :utc_offset]
    }
  end
  
  scope :filter_base, ->{ select('kms.id, kms.name') }
  scope :api_base, ->{ select('kms.id, kms.city_id, kms.name, kms.shops_count, kms.public_meter_length, kms.dedicated_meter_length, kms.peak_deliveries, kms.peak_disruptions, kms.peak_traffic, kms.lat, kms.lng, kms.street_lat, kms.street_lng').with_city }
  
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
  
  def api_chart_shop_totals
    @api_chart_shop_totals ||= Api::ShopTotal.api_chart_base.filter_by_km(self.id)
  end
  
  def api_chart_streets
    @api_chart_streets ||= Api::Street.api_chart_base.filter_by_km(self.id)
  end
  
  def api_chart_deliveries
    @api_chart_deliveries ||= Api::DeliveriesDisruption.api_deliveries_chart_base.filter_by_km(self.id)
  end
  
  def api_chart_traffic_count_totals
    @api_chart_traffic_count_totals ||= ->{
      el = Api::TrafficCountTotal.find_chart_base_by_km(self.id)
      el.as_chart unless el.nil?
    }.call
  end
  
  def api_chart_disruptions
    @api_chart_disruptions ||= Api::DeliveriesDisruption.api_disruptions_chart_base.filter_by_km(self.id)
  end
  
end