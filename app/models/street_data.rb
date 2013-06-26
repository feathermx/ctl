class StreetData < ActiveRecord::FmxBase

  include BlockStreetable
  
  scope :base, ->{ select("street_data.id, street_data.street_id, street_data.way, street_data.driving_lanes, street_data.bike_lanes, street_data.parking_lanes, street_data.public_transport_lanes, street_data.extra_crosswalks, street_data.width_of_sidewalks, street_data.transport_stop, street_data.has_loading_area, street_data.loading_area_length, street_data.has_parking_area, street_data.parking_area_length, street_data.parking_payment") }
  scope :base_count, ->{ select("COUNT(street_data.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  
  module Way
    OneWay = 1
    TwoWays = 2
    
    List =  {
      OneWay => {
        name: ''
      },
      TwoWays => {
        name: ''
      }
    }
    
    def self.keys
      @@keys ||= List.keys
    end
  end
  
  module TransportStop
    Transit = 'T'
    BusStop = 'B'
    
    List = {
      Transit => {
        name: ''
      },
      BusStop => {
        name: ''
      }
    } 
    
    def self.keys
      @@keys ||= List.keys
    end
    
  end
  
  module ParkingPayment
    Meter = 'M'
    Permit = 'P'
    Free = 'F'
    
    List = {
      Meter => {
        name: ''
      },
      Permit => {
        name: ''
      },
      Free => {
        name: ''
      }
    }
    
    def self.keys
      @@keys ||= List.keys
    end
  end
  
  validates :way, presence: true, numericality: { only_integer: true }, inclusion: { in: Way.keys }
  validates :driving_lanes, numericality { only_integer: true }, allow_blank: true
  validates :bike_lanes, numericality { only_integer: true }, allow_blank: true
  validates :parking_lanes, numericality { only_integer: true }, allow_blank: true
  validates :public_transport_lanes, numericality { only_integer: true }, allow_blank: true
  validates :extra_crosswalks, numericality { only_integer: true }, allow_blank: true
  validates :width_of_sidewalks, presence: true, numericality { only_integer: true }
  validates :transport_stop, length { maximum: 10 }, allow_blank: true, inclusion: { in: TransportStop.keys }
  validates :has_loading_area, numericality: { only_integer: true }, inclusion: { in: self.boolean_int }, allow_blank: true
  validates :loading_area_length, numericality: true, allow_blank: true
  validates :has_parking_area, numericality: { only_integer: true }, inclusion: { in: self.boolean_int }, allow_blank: true
  validates :parking_area_length, numericality: true, allow_blank: true
  validates :parking_payment, length { is: 1 }, inclusion { in: ParkingPayment.keys }
  
end
