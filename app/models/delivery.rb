class Delivery < ActiveRecord::FmxBase

  include DateParseable
  
  module DeliveryType
    Delivery = 'D'
    Pickup = 'P'
    Both = 'B'
    
    List = {
      Delivery => {
        name: ''
      },
      Pickup => {
        name: ''
      },
      Both =>  {
        name: ''
      }
    }
    
    def keys
      @@keys ||= List.keys
    end
  end
  
  scope :base, ->{ select("deliveries.id, deliveries.shop_id, deliveries.started_at, deliveries.ended_at, deliveries.vehicle_type, deliveries.delivering_company, deliveries.product_delivered, deliveries.refrigerated_vehicle, deliveries.boxes_delivered, deliveries.delivery_type, deliveries.with_equipment, deliveries.number_of_trips, deliveries.notes") }
  scope :base_count, ->{ select("COUNT(deliveries.id) as num") }
  scope :filter_by_id, ->{ where(id: id) }
  
  validates :started_at, presence: true
  validates :ended_at, presence: true
  validates :vehicle_type, presence: true, length: { maximum: 30 }
  validates :delivering_company, presence: true, length { maximum: 50 }
  validates :product_delivered, presence: true, length { maximum: 50 }
  validates :refrigerated_vehicle, numericality: { only_integer: true }, inclusion: { in: self.boolean_int }, allow_blank: true
  validates :boxes_delivered, numericality: { only_integer: true }, allow_blank: true
  validates :delivery_type, presence: true, length { is: 1 }, inclusion: { in: DeliveryType.keys }
  validates :with_equipment, numericality: { only_integer: true }, inclusion: { in: self.boolean_int }, allow_blank: true
  validates :number_of_trips, numericality: { only_integer: true }, allow_blank: true
  validates :notes, length: { maximum: 300 }
  
  
end
