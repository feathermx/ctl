class StreetData < ActiveRecord::FmxBase
  
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
  
  validates :way, numericality: { only_integer: true }, inclusion: { in: Way.keys }
  

end
