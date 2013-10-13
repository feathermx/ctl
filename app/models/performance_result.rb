class PerformanceResult < ActiveRecord::FmxBase
  
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
  
  #Scopes
  scope :base, ->{ select('performance_results.id, performance_results.km_id, performance_results.technology, performance_results.meter_length_time, performance_results.peak_deliveries_time, performance_results.peak_disruptions_time, performance_results.peak_traffic_time, performance_results.disruptions_times_time, performance_results.delivery_times_time, performance_results.chart_times_time, performance_results.tracks_time, performance_results.shops_time, performance_results.deliveries_time, performance_results.traffic_disruptions_time, performance_results.streets_time, performance_results.streets_meter_length_time, performance_results.streets_track_count_time, performance_results.streets_location_time, performance_results.deliveries_disruptions_time, performance_results.traffic_count_totals_time, performance_results.shop_totals_time performance_results.delivery_totals_time performance_results.shop_totals_time, performance_results.delivery_totals_time, performance_results.total_time, performance_results.created_at') }
  scope :base_count, ->{ select('COUNT(performance_results.id) as num') }
  scope :filter_by_id, ->(id){ where(id: id) }
  scope :filter_by_km, ->(km_id){ where(km_id: km_id) }
  
  #Attributes
  attr_protected :streets_time, :total_time
  
  #Validatios
  validates :km_id, :technology, :meter_length_time, :peak_deliveries_time, :peak_disruptions_time, :peak_traffic_time, :disruptions_times_time, :delivery_times_time, :chart_times_time, :tracks_time, :shops_time, :deliveries_time, :traffic_disruptions_time, :streets_time, :streets_meter_length_time, :streets_track_count_time, :streets_location_time, :deliveries_disruptions_time, :traffic_count_totals_time, :shop_totals_time, :delivery_totals_time, presence: true
  validates :technology, :meter_length_time, :peak_deliveries_time, :peak_disruptions_time, :peak_traffic_time, :disruptions_times_time, :delivery_times_time, :chart_times_time, :tracks_time, :shops_time, :deliveries_time, :traffic_disruptions_time, :streets_time, :streets_meter_length_time, :streets_track_count_time, :streets_location_time, :deliveries_disruptions_time, :traffic_count_totals_time, :shop_totals_time, :delivery_totals_time, numericality: true
  validates :technology, inclusion: { in: Technology.keys }
  
  #Methods
  
  protected
  
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
  
  
end
