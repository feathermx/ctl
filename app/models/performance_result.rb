class PerformanceResult < ActiveRecord::FmxBase
  
  #Constants  
  UsecSecs = 1000.0 
   
  #Concerns
  include Summable
  
  #Modules
  module Technology
    LangBase = 'app.model.performance_result.technology'
    Sequential = 1
    SequentialDb = 2
    Parallel = 4
    GpuDb = 8
    
    List = {
      Sequential => {
        name: I18n.t("#{LangBase}.sequential")
      },
      SequentialDb => {
        name: I18n.t("#{LangBase}.sequential_db")
      },
      Parallel => {
        name: I18n.t("#{LangBase}.parallel")
      },
      GpuDb => {
        name: I18n.t("#{LangBase}.gpu_db")
      }
    }
    
    def self.keys
      @@keys ||= List.keys
    end
    
  end
  
  module TimeFields
    LangBase = 'app.model.performance_result'
    LangTimeFields = "#{LangBase}.time_fields"
    LangStreetFields = "#{LangBase}.street_time_fields"
    MeterLength = 0
    PeakDeliveries = 1
    PeakDisruptions = 2
    PeakTraffic = 3
    DisruptionTimes = 4
    DeliveryTimes = 5
    ChartTimes = 6
    Tracks = 7
    Shops = 8
    Deliveries = 9
    TrafficDisruptions = 10
    Streets = 11
    DeliveriesDisruptions = 12
    TrafficCountTotals = 13
    ShopTotals = 14
    DeliveryTotals = 15
    
    #Streets
    StreetsMeterLength = 16
    StreetsTrackCount = 17
    StreetsLocation = 18
    
    
    List = {
      MeterLength => {
        field: 'meter_length',
        name: I18n.t("#{LangTimeFields}.meter_length")
      },
      PeakDeliveries => {
        field: 'peak_deliveries',
        name: I18n.t("#{LangTimeFields}.peak_deliveries")
      },
      PeakDisruptions => {
        field: 'peak_disruptions',
        name: I18n.t("#{LangTimeFields}.peak_deliveries")
      },
      PeakTraffic => {
        field: 'peak_traffic',
        name: I18n.t("#{LangTimeFields}.peak_traffic")
      },
      DisruptionTimes => {
        field: 'disruptions_times',
        name: I18n.t("#{LangTimeFields}.disruptions_times")
      },
      DeliveryTimes => {
        field: 'delivery_times',
        name: I18n.t("#{LangTimeFields}.delivery_times")
      },
      ChartTimes => {
        field: 'chart_times',
        name: I18n.t("#{LangTimeFields}.chart_times")
      },
      Tracks => {
        field: 'tracks',
        name: I18n.t("#{LangTimeFields}.tracks")
      },
      Shops => {
        field: 'shops',
        name: I18n.t("#{LangTimeFields}.shops")
      },
      Deliveries => {
        field: 'deliveries',
        name: I18n.t("#{LangTimeFields}.deliveries")
      },
      TrafficDisruptions => {
        field: 'traffic_disruptions',
        name: I18n.t("#{LangTimeFields}.traffic_disruptions")
      },
      Streets => {
        field: 'streets',
        name: I18n.t("#{LangTimeFields}.streets")
      },
      DeliveriesDisruptions => {
        field: 'deliveries_disruptions',
        name: I18n.t("#{LangTimeFields}.deliveries_disruptions")
      },
      TrafficCountTotals => {
        field: 'traffic_count_totals',
        name: I18n.t("#{LangTimeFields}.traffic_count_totals")
      },
      ShopTotals => {
        field: 'shop_totals',
        name: I18n.t("#{LangTimeFields}.shop_totals")
      },
      DeliveryTotals => {
        field: 'delivery_totals',
        name: I18n.t("#{LangTimeFields}.delivery_totals")
      }
    }
    
    StreetList = {
      StreetsMeterLength => {
        field: 'streets_meter_length',
        name: I18n.t("#{LangStreetFields}.streets_meter_length")
      },
      StreetsTrackCount => {
        field: 'streets_track_count',
        name: I18n.t("#{LangStreetFields}.streets_track_count")
      },
      StreetsLocation => {
        field: 'streets_location',
        name: I18n.t("#{LangStreetFields}.streets_location")
      }
    }
    
    def self.full_list
      @@full_list ||= List.merge(StreetList)
    end
    
    def self.keys
      @@keys ||= self.full_list.keys
    end
    
    def self.find(key)
      const_key = self.const_get(key)
      self.full_list[const_key]
    end
  end
  
  #Scopes
  scope :base, ->{ select('performance_results.id, performance_results.km_id, performance_results.technology, performance_results.meter_length_time, performance_results.peak_deliveries_time, performance_results.peak_disruptions_time, performance_results.peak_traffic_time, performance_results.disruptions_times_time, performance_results.delivery_times_time, performance_results.chart_times_time, performance_results.tracks_time, performance_results.shops_time, performance_results.deliveries_time, performance_results.traffic_disruptions_time, performance_results.streets_time, performance_results.streets_meter_length_time, performance_results.streets_track_count_time, performance_results.streets_location_time, performance_results.deliveries_disruptions_time, performance_results.traffic_count_totals_time, performance_results.shop_totals_time, performance_results.delivery_totals_time, performance_results.shop_totals_time, performance_results.delivery_totals_time, performance_results.total_time, performance_results.created_at') }
  scope :base_count, ->{ select('COUNT(performance_results.id) as num') }
  scope :filter_by_id, ->(id){ where(id: id) }
  scope :filter_by_km, ->(km_id){ where(km_id: km_id) }
  scope :with_km, ->{ joins('JOIN kms ON kms.id = performance_results.km_id') }
  
  #Attributes
  attr_accessor :pool
  attr_protected :streets_time, :total_time, :technology
  
  #Validatios
  validates :km_id, :technology, :meter_length_time, :peak_deliveries_time, :peak_disruptions_time, :peak_traffic_time, :disruptions_times_time, :delivery_times_time, :chart_times_time, :tracks_time, :shops_time, :deliveries_time, :traffic_disruptions_time, :streets_time, :streets_meter_length_time, :streets_track_count_time, :streets_location_time, :deliveries_disruptions_time, :traffic_count_totals_time, :shop_totals_time, :delivery_totals_time, presence: true
  validates :technology, :meter_length_time, :peak_deliveries_time, :peak_disruptions_time, :peak_traffic_time, :disruptions_times_time, :delivery_times_time, :chart_times_time, :tracks_time, :shops_time, :deliveries_time, :traffic_disruptions_time, :streets_time, :streets_meter_length_time, :streets_track_count_time, :streets_location_time, :deliveries_disruptions_time, :traffic_count_totals_time, :shop_totals_time, :delivery_totals_time, numericality: true
  
  #Methods
  
  def total_time=(val)
    @total_time_secs = nil
    write_attribute(:total_time, val)
  end
  
  def streets_time=(val)
    @streets_time_secs = nil
    write_attribute(:streets_time, val)
  end
  
  def total_time_secs
    @total_time_secs ||= self.time_secs(self.total_time)
  end
  
  def streets_time_secs
    @streets_time_secs ||= self.time_secs(self.streets_time)
  end
  
  def km
    @km ||= ->{
      Km.find_by_id(self.km_id) unless self.km_id.blank?
    }.call
  end
  
  def c_at
    @c_at ||= ->{
      (self.created_at.to_i * 1000) unless self.created_at.nil?
    }.call
  end
  
  def pool
    @pool ||= {}
  end
  
  def set_technology(parallel, parallel_db)
    val = 0
    val = val | (parallel ? Technology::Parallel : Technology::Sequential)
    val = val | (parallel_db ? Technology::GpuDb : Technology::SequentialDb)
    self.technology = val
  end
  
  def exec_block(key)
    sw = StopWatch::StopWatch.new
    sw.start
    field = TimeFields.find(key)
    self.pool[key] = [] if self.parallel?
    yield
    if self.parallel?
      self.pool[key].each do |t|
        t.join
      end
    end
    sw.stop
    self.send("#{field[:field]}_time=", sw.elapsed)
  end
  
  def exec(key)
    field = TimeFields.find(key)
    if self.parallel?
      t = Thread.new do
        yield
      end
      self.pool[key].push(t)
    else
      yield
    end
  end
  
  protected
  
  def technology=(val)
    @bool_parallel = @bool_sequential = @bool_parallel_db = @bool_sequential_db = nil
    write_attribute(:technology, val.to_i) unless val.nil?
  end
  
  def parallel?
    @bool_parallel ||= ((Technology::Parallel & self.technology) == Technology::Parallel)
  end
  
  def sequential?
    @bool_sequential ||= !self.parallel?
  end
  
  def parallel_db?
    @bool_parallel_db ||= ((Technology::GpuDb & self.technology) == Technology::GpuDb)
  end
  
  def sequential_db?
    @bool_sequential_db ||= !self.parallel_db?
  end
  
  def self.time_fields
    @@time_fields ||= %w{meter_length peak_deliveries peak_disruptions peak_traffic disruptions_times delivery_times chart_times tracks shops deliveries traffic_disruptions streets deliveries_disruptions traffic_count_totals shop_totals delivery_totals}
  end
  
  def self.streets_time_fields
    @@streets_time_fields ||= %w{streets_meter_length streets_track_count streets_location}
  end
  
  #summable concern methods
  def summable_fields
    @summable_fields ||= [
      SumField.new(nspc: 'time', fields: self.class.streets_time_fields, field_name: 'streets_time'),
      SumField.new(nspc: 'time', fields: self.class.time_fields, field_name: 'total_time')
    ]
  end
  
  def time_secs(val)
    (val.to_i / UsecSecs) unless val.blank?
  end
  
end
