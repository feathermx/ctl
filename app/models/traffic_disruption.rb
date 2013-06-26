class TrafficDisruption < ActiveRecord::FmxBase
  
  module AffectionType
    
    Slowed = 'S'
    Stopped = 'C'
    
    List = {
      Slowed => {
        name: ''
      },
      Stopped => {
        name: ''
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
        name: ''
      },
      Bus => {
        name: ''
      },
      ParkingViolation => {
        name: ''
      },
      EmergencyVehicle => {
        name: ''
      },
      Crosswalk => {
        name: ''
      },
      VehicleManeuvers => {
        name: ''
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
        name: ''
      },
      Utility => {
        name: ''
      },
      Waste => {
        name: ''
      },
      Taxi => {
        name: ''
      },
      PrivateCar => {
        name: ''
      },
      Accident => {
        name: ''
      }
    }
    
    def self.keys
      @@keys ||= List.keys
    end
      
  end
  
  include BlockStreetable
  
  scope :base, ->{ select("traffic_disruptions.id, traffic_disruptions.street_id, traffic_disruptions.source, traffic_disruptions.vehicle_type, traffic_disruptions.started_at, traffic_disruptions.ended_at, traffic_disruptions.more_than_five_secs, traffic_disruptions.disruption_type, traffic_disruptions.blocked_lanes, traffic_disruptions.vehicles_affected, traffic_disruptions.slowed_or_stop, traffic_disruptions.notes") }
  scope :base_count, ->{ select("COUNT(traffic_disruptions.id) as num") }
  scope :filter_by_id, ->{ where(id: id) }
  
  validates :source, presence: true, length: { is: 1 }, inclusion: { in: Source.keys }
  validates :vehicle_type, presence: true, length: { maximum: 30 }
  validates :more_than_five_secs, presence: true, numericality: { only_integer: true }, inclusion: { in: self.boolean_int }
  validates :disruption_type, length: { is: 1 }, inclusion: { in: DisruptionType.keys }, allow_blank: true
  validates :blocked_lanes, numericality: { only_integer: true }, allow_blank: true
  validates :vehicles_affected, numericality: { only_integer: true }, allow_blank: true
  validates :slowed_or_stop, length: { is: 1 }, inclusion: { in: AffectionType.keys }, allow_blank: true
  validates :notes, length: { in: 2..300 }, allow_blank: true
  
end