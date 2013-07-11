class TrafficDisruption < ActiveRecord::FmxBase
  
  module AffectionType
    
    Slowed = 'S'
    Stopped = 'C'
    
    List = {
      Slowed => {
        name: I18n.t('app.model.traffic_disruption.affection_type.slowed')
      },
      Stopped => {
        name: I18n.t('app.model.traffic_disruption.affection_type.stopped')
      }
    }
    
    def self.keys
      @@keys ||= List.keys
    end
    
  end
  
  module DisruptionType
    
    PedestrianSidewalk = 'P'
    Bus = 'B'
    ParkingViolation = 'V'
    EmergencyVehicle = 'E'
    Crosswalk = 'C'
    VehicleManeuvers = 'M'
    
    List = {
      PedestrianSidewalk => {
        name: I18n.t('app.model.traffic_disruption.disruption_type.pedestrian_sidewalk')
      },
      Bus => {
        name: I18n.t('app.model.traffic_disruption.disruption_type.bus')
      },
      ParkingViolation => {
        name: I18n.t('app.model.traffic_disruption.disruption_type.parking_violation')
      },
      EmergencyVehicle => {
        name: I18n.t('app.model.traffic_disruption.disruption_type.emergency_vehicle')
      },
      Crosswalk => {
        name: I18n.t('app.model.traffic_disruption.disruption_type.crosswalk')
      },
      VehicleManeuvers => {
        name: I18n.t('app.model.traffic_disruption.disruption_type.vehicle_maneuvers')
      }
    }
    
    def self.keys
      @@keys ||= List.keys
    end
    
  end
  
  module Source
    
    Freight = 'F'
    Utility = 'U'
    Waste = 'W'
    Taxi = 'T'
    PrivateCar = 'P'
    Accident = 'A'
    
    List = {
      Freight => {
        name: I18n.t('app.model.traffic_disruption.source.freight')
      },
      Utility => {
        name: I18n.t('app.model.traffic_disruption.source.utility')
      },
      Waste => {
        name: I18n.t('app.model.traffic_disruption.source.waste')
      },
      Taxi => {
        name: I18n.t('app.model.traffic_disruption.source.taxi')
      },
      PrivateCar => {
        name: I18n.t('app.model.traffic_disruption.source.private_car')
      },
      Accident => {
        name: I18n.t('app.model.traffic_disruption.source.accident')
      }
    }
    
    def self.keys
      @@keys ||= List.keys
    end
      
  end
  
  module LengthType
    
    Small = 0
    Med = 1
    Big = 2
    
    List = {
      Small => {
        name: I18n.t('app.model.traffic_disruption.length_type.small'),
        range: (0..5)
      },
      Med => {
        name: I18n.t('app.model.traffic_disruption.length_type.med'),
        range: (6..30)
      },
      Big => {
        name: I18n.t('app.model.traffic_disruption.length_type.big'),
        start: 30
      }
    }
    
    def self.keys
      @@keys ||= List.keys
    end
    
  end
  
  include BlockStreetable
  include DateParsable
  include Kmable
  include Peakable
  include Localizable
  
  scope :base, ->{ select("traffic_disruptions.id, traffic_disruptions.km_id, traffic_disruptions.street_id, traffic_disruptions.source, traffic_disruptions.vehicle_type, traffic_disruptions.started_at, traffic_disruptions.ended_at, traffic_disruptions.more_than_five_secs, traffic_disruptions.disruption_type, traffic_disruptions.blocked_lanes, traffic_disruptions.vehicles_affected, traffic_disruptions.slowed_or_stop, traffic_disruptions.notes, traffic_disruptions.length_type, traffic_disruptions.lat, traffic_disruptions.lng") }
  scope :base_count, ->{ select("COUNT(traffic_disruptions.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  
  attr_protected :length_type
  
  validates :started_at, presence: true
  validates :ended_at, presence: true
  validates :source, presence: true, length: { is: 1 }, inclusion: { in: Source.keys }
  validates :vehicle_type, presence: true, length: { maximum: 30 }
  validates :more_than_five_secs, presence: true, numericality: { only_integer: true }, inclusion: { in: self.boolean_int }
  validates :disruption_type, length: { is: 1 }, inclusion: { in: DisruptionType.keys }, allow_blank: true
  validates :blocked_lanes, numericality: true, allow_blank: true
  validates :vehicles_affected, numericality: { only_integer: true }, allow_blank: true
  validates :slowed_or_stop, length: { is: 1 }, inclusion: { in: AffectionType.keys }, allow_blank: true
  validates :notes, length: { in: 2..300 }, allow_blank: true
  validates :length_type, numericality: { only_integer: true }, inclusion: { in: LengthType.keys }, allow_nil: true
  
  before_save :set_length_type
  
  def s_at
    @s_at ||= ->{
      (self.started_at.to_i * 1000) unless self.started_at.nil?
    }.call
  end
  
  def e_at
    @e_at ||= ->{
      (self.ended_at.to_i * 1000) unless self.ended_at.nil?
    }.call
  end
  
  def started_at=(val) 
    write_attribute(:started_at, date_time_val(val))
  end
  
  def ended_at=(val) 
    write_attribute(:ended_at, date_time_val(val))
  end
  
  def source=(val)
    write_attribute(:source, upcase(val))
  end
  
  def disruption_type=(val)
    write_attribute(:disruption_type, upcase(val))
  end
  
  def slowed_or_stop=(val)
    write_attribute(:slowed_or_stop, upcase(val))
  end
  
  def time_diff
    @time_diff ||= (self.ended_at.to_i - self.started_at.to_i)
  end
  
  protected
  
  def date_parsable_format
    @date_parsable_format ||= Settings.get('csv.date_full_format')
  end
  
  def self.peak_field
    "started_at"
  end
  
  def location_field
    @location_field ||= "started_at"
  end
  
  def set_length_type
    if self.length_type.nil?
      val = nil
      LengthType::List.each do |key, el|
        range = el[:range]
        unless range.nil?
          val = key if range.include?(self.time_diff)
        else
          start = el[:start]
          val = key if self.time_diff > start
        end
        break unless val.nil?
      end
      self.length_type = val
    end
  end
  
  
end
