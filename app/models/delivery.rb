class Delivery < ActiveRecord::FmxBase

  include BlockStreetable
  include DateParsable
  include Kmable
  
  module DeliveryType
    Delivery = 'D'
    Pickup = 'P'
    Both = 'B'
    
    List = {
      Delivery => {
        name: I18n.t('app.model.delivery.delivery_type.grocery')
      },
      Pickup => {
        name: I18n.t('app.model.delivery.delivery_type.pickup')
      },
      Both =>  {
        name: I18n.t('app.model.delivery.delivery_type.both')
      }
    }
    
    def self.keys
      @@keys ||= List.keys
    end
    
  end
  
  scope :base, ->{ select("deliveries.id, deliveries.km_id, deliveries.street_id, deliveries.shop_id, deliveries.started_at, deliveries.ended_at, deliveries.vehicle_type, deliveries.delivering_company, deliveries.product_delivered, deliveries.refrigerated_vehicle, deliveries.boxes_delivered, deliveries.delivery_type, deliveries.with_equipment, deliveries.number_of_trips, deliveries.notes") }
  scope :base_count, ->{ select("COUNT(deliveries.id) as num") }
  scope :filter_by_id, ->{ where(id: id) }
  
  validates :started_at, presence: true
  validates :ended_at, presence: true
  validates :vehicle_type, presence: true, length: { maximum: 30 }
  validates :delivering_company, presence: true, length: { maximum: 50 }
  validates :product_delivered, presence: true, length: { maximum: 50 }
  validates :refrigerated_vehicle, numericality: { only_integer: true }, inclusion: { in: self.boolean_int }, allow_blank: true
  validates :boxes_delivered, numericality: { only_integer: true }, allow_blank: true
  validates :delivery_type, presence: true, length: { is: 1 }, inclusion: { in: DeliveryType.keys }
  validates :with_equipment, numericality: { only_integer: true }, inclusion: { in: self.boolean_int }, allow_blank: true
  validates :number_of_trips, numericality: { only_integer: true }, allow_blank: true
  validates :notes, length: { maximum: 300 }
  validate :valid_shop_id
  
  def valid_shop_id
    errors.add(:shop_id, I18n.t('activerecord.errors.messages.not_found')) if self.shop_id.nil?
  end
  
  def shop_id=(val)
    shop = Shop.find_by_shop_id(val)
    write_attribute(:shop_id, shop.id) unless shop.nil?
  end
  
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
  
  def delivery_type=(val)
    write_attribute(:delivery_type, upcase(val))
  end
  
  
end