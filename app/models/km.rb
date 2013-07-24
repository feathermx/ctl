class Km < ActiveRecord::FmxBase

  scope :base, ->{ select("kms.id, kms.is_active, kms.tracks_count, kms.traffic_counts_count, kms.traffic_disruptions_count, kms.street_data_count, kms.parking_restrictions_count, kms.shops_count, kms.public_meter_length, kms.dedicated_meter_length, kms.peak_deliveries, kms.peak_delivery_hour, kms.peak_disruptions, kms.peak_disruption_hour, kms.peak_traffic, kms.peak_traffic_hour, kms.min_disruption_time, kms.max_disruption_time, kms.min_delivery_time, kms.max_delivery_time, kms.chart_start_time, kms.chart_end_time, kms.deliveries_count, kms.city_id, kms.name, kms.description, kms.comments, kms.lat, kms.lng, kms.street_lat, kms.street_lng") }
  scope :base_count, ->{ select("COUNT(kms.id) as num") }
  scope :base_id, ->{ select("kms.id") }
  scope :with_city, ->{ select('cities.name as city_name').joins('JOIN cities ON cities.id = kms.city_id') }
  scope :filter_by_id, ->(id){ where(id: id) }
  scope :filter_by_city, ->(city_id){ where(city_id: city_id) }
  scope :filter_active, ->{ where(is_active: 1) }
  scope :ascending, ->{ order('kms.name ASC') }
  scope :descending, ->{ order('kms.created_at DESC') }
  
  attr_accessor :active_changed
  attr_protected :is_active, :public_meter_length, :dedicated_meter_length, :peak_deliveries, :peak_delivery_hour, :peak_disruptions, :peak_disruption_hour, :peak_traffic, :peak_traffic_hour, :min_disruption_time, :max_disruption_time, :min_delivery_time, :max_delivery_time, :chart_start_time, :chart_end_time, :city_id, :track_count, :traffic_counts_count, :traffic_disruption_count, :street_data_count, :parking_restrictions_count, :shops_count, :delivery_count
  
  validates :street_lat, :street_lng, presence: true
  validates :is_active, numericality: { only_integer: true }, inclusion: { in: self.boolean_int }
  validates :city_id, :name, :lat, :lng, presence: true
  validates :city_id, numericality: { only_integer: true }
  validates :public_meter_length, numericality: true, allow_nil: true
  validates :dedicated_meter_length, numericality: true, allow_nil: true
  validates :peak_deliveries, numericality: { only_integer: true }, allow_nil: true
  validates :peak_disruptions, numericality: { only_integer: true }, allow_nil: true
  validates :peak_traffic, numericality: { only_integer: true }, allow_nil: true
  validates :name, length: { in: 2..100 }
  validates :description, length: { in: 2..300 }, allow_blank: true
  validates :comments, length: { in: 2..300 }, allow_blank: true
  validates :lat, numericality: true
  validates :lng, numericality: true
  validates :street_lat, numericality: true
  validates :street_lng, numericality: true
  
  before_save :set_active_state
  before_destroy :remove_active_count
  
  def min_delivery_time_at
    @min_delivery_time_at ||= ->{
      (self.min_delivery_time.to_i * 1000) unless self.min_delivery_time.nil? 
    }.call
  end
  
  def max_delivery_time_at
    @max_delivery_time_at ||= ->{
      (self.max_delivery_time.to_i * 1000) unless self.max_delivery_time.nil? 
    }.call
  end
  
  def full_name
    @full_name ||= "#{self.name}, #{self[:city_name]}"
  end
  
  def city
    @city ||= City.find_by_id(self.city_id)
  end
  
  def time_zone
    @time_zone ||= self.city.time_zone
  end
  
  def utc_offset
    @utc_offset ||= ->{
      self.time_zone.now.utc_offset unless self.time_zone.nil?
    }.call
  end
  
  def tracks
    @tracks ||= Track.base.filter_by_km(self.id)
  end
  
  def traffic_counts
    @traffic_counts ||= TrafficCount.base.filter_by_km(self.id)
  end
  
  def shops
    @shops ||= Shop.base.filter_by_km(self.id)
  end
  
  def deliveries
    @deliveries ||= Delivery.base.filter_by_km(self.id)
  end
  
  def traffic_disruptions
    @traffic_disruptions ||= TrafficDisruption.base.filter_by_km(self.id)
  end
  
  def street_data
    @street_data ||= StreetData.base.filter_by_km(self.id)
  end
  
  def parking_restrictions
    @parking_restrictions ||= ParkingRestriction.base.filter_by_km(self.id)
  end
  
  def streets
    @streets ||= Street.base.filter_by_km(self.id)
  end
  
  def deliveries_disruptions
    @deliveries_disruptions ||= DeliveriesDisruption.base.filter_by_km(self.id)
  end
  
  def traffic_count_totals
    @traffic_count_totals ||= TrafficCountTotal.base.filter_by_km(self.id)
  end
  
  def shop_totals
    @shop_totals ||= ShopTotal.base.filter_by_km(self.id)
  end
  
  def blocks
    @blocks ||= Block.base.filter_by_km(self.id)
  end
  
  def is_active=(val)
    curr_active = self.is_active.to_i
    val = val.to_i
    @bool_active = nil
    self.active_changed = true if curr_active != val
    write_attribute(:is_active, val)
  end
  
  def active?
    @bool_active ||= self.is_active.to_i == 1
  end
  
  def purge_data
    self.destroy_deliveries
    self.destroy_shops
    self.destroy_traffic_counts
    self.destroy_traffic_disruptions
    self.destroy_parking_restrictions
    self.destroy_street_data
    self.destroy_streets
    self.destroy_blocks
    self.deliveries_count = self.shops_count = self.traffic_counts_count = self.parking_restrictions_count = self.street_data_count = 0
    self.is_active = 0
    self.save
  end
  
  protected
  
  def reset_active_fields
    self.public_meter_length = self.dedicated_meter_length = self.peak_deliveries = self.peak_disruptions = self.peak_traffic = 0
    self.peak_delivery_hour = self.peak_disruption_hour = self.peak_traffic_hour = self.min_disruption_time = self.max_disruption_time = self.min_delivery_time = self.max_delivery_time = self.chart_start_time = self.chart_end_time = nil
  end
  
  def set_active_state
    if self.active_changed
      if self.active?
        self.reset_active_fields
        self.set_meter_length
        self.set_peak_deliveries
        self.set_peak_disruptions
        self.set_peak_traffic
        self.set_disruption_times
        self.set_delivery_times
        self.set_chart_times
        self.set_tracks
        self.set_shops
        self.set_deliveries
        self.set_traffic_disruptions
        self.set_streets
        self.set_deliveries_disruptions
        self.set_traffic_count_totals
        self.set_shop_totals
        self.add_active_count
      else
        self.substract_active_count
      end
    end
  end
  
  def add_active_count
    self.city.active_count = self.city.active_count.to_i + 1
    self.city.save
  end
  
  def substract_active_count
    self.city.active_count = self.city.active_count.to_i - 1
    self.city.save
  end
  
  def set_traffic_count_totals
    self.destroy_traffic_count_totals
    el = TrafficCountTotal.generate(self)
    el.save
  end
  
  def set_shop_totals
    self.destroy_shop_totals
    Shop::ShopType::List.each do |key, val|
      el = ShopTotal.generate(key, self.id)
      el.save
    end
  end
  
  def set_deliveries_disruptions
    self.destroy_deliveries_disruptions
    unless self.chart_start_time.nil? || self.chart_end_time.nil?
      ((self.chart_start_time.hour)..(self.chart_end_time.hour)).each do |hour|
        el = DeliveriesDisruption.generate(hour, self)
        el.save
      end
    end
  end
  
  def set_streets
    self.streets.each do |el|
      el.set_meter_length
      el.set_track_count
      el.set_location
      el.save
    end
  end
  
  def set_traffic_disruptions
    self.traffic_disruptions.each do |el|
      el.set_location
      el.save
    end
  end
  
  def set_deliveries
    self.deliveries.each do |el|
      el.set_location
      el.save
    end
  end
  
  def set_shops
    self.shops.each do |el|
      el.set_location
      el.save
    end
  end
  
  def set_tracks
    self.tracks.each do |el|
      el.set_street_id
      el.save
    end
  end
  
  def set_chart_times
    unless self.min_disruption_time.nil? || self.min_delivery_time.nil?
      self.chart_start_time = (self.min_disruption_time < self.min_delivery_time) ? self.min_disruption_time : self.min_delivery_time
    end
    unless self.max_disruption_time.nil? || self.max_delivery_time.nil?
      self.chart_end_time = (self.max_disruption_time > self.max_delivery_time) ? self.max_disruption_time : self.max_delivery_time
    end
  end
  
  def set_disruption_times
    self.min_disruption_time = TrafficDisruption.min_hour_for_km(self.id)
    self.max_disruption_time = TrafficDisruption.max_hour_for_km(self.id)
  end
  
  def set_delivery_times
    self.min_delivery_time = Delivery.min_hour_for_km(self.id)
    self.max_delivery_time = Delivery.max_hour_for_km(self.id)
  end
  
  def set_meter_length
    data = StreetData.meter_base.filter_by_km(self.id).first
    self.public_meter_length = data[:public_meter_length].to_f
    self.dedicated_meter_length = data[:dedicated_meter_length].to_f
  end
  
  def set_peak_deliveries
    peak = self.get_peak(Delivery)
    self.peak_delivery_hour = "#{peak[1]}:00:00 +00:00"
    self.peak_deliveries = peak[0]
  end
  
  def set_peak_disruptions
    peak = self.get_peak(TrafficDisruption)
    self.peak_disruption_hour = "#{peak[1]}:00:00 +00:00"
    self.peak_disruptions = peak[0]
  end
  
  def set_peak_traffic
    peak = self.get_peak(TrafficCount, TrafficCount.peak_base)
    self.peak_traffic_hour = "#{peak[1]}:00:00 +00:00"
    self.peak_traffic = peak[0]
  end
  
  def get_peak(cls, base=nil)
    results = []
    (0..23).each do |hour|
      results.push(cls.peak_for_hour(hour, self.id, base))
    end
    results.each_with_index.max
  end
  
  def destroy_blocks
    self.blocks.each do |el|
      el.destroy
    end
    @blocks = nil
  end
  
  def destroy_streets
    self.streets.each do |el|
      el.destroy
    end
    @streets = nil
  end
  
  def destroy_shops
    self.shops.each do |el|
      el.destroy
    end
    @shops = nil
  end
  
  def destroy_street_data
    self.street_data.each do |el|
      el.destroy
    end
    @street_data = nil
  end
  
  def destroy_parking_restrictions
    self.parking_restrictions.each do |el|
      el.destroy
    end
    @parking_restrictions = nil
  end
  
  def destroy_traffic_disruptions
    self.traffic_disruptions.each do |el|
      el.destroy
    end
    @traffic_disruptions = nil
  end
  
  def destroy_traffic_counts
    self.traffic_counts.each do |el|
      el.destroy
    end
    @traffic_counts = nil
  end
  
  def destroy_deliveries
    self.deliveries.each do |el|
      el.destroy
    end
    @deliveries = nil
  end
  
  def destroy_deliveries_disruptions
    self.deliveries_disruptions.each do |el|
      el.destroy
    end
    @deliveries_disruptions = nil
  end
  
  def destroy_traffic_count_totals
    self.traffic_count_totals.each do |el|
      el.destroy
    end
    @traffic_count_totals = nil
  end
  
  def destroy_shop_totals
    self.shop_totals.each do |el|
      el.destroy
    end
    @shop_totals = nil
  end
  
  def remove_active_count
    self.substract_active_count if self.active?
  end
  
  
end