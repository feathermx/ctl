class Shop < ActiveRecord::FmxBase

  include BlockStreetable
  include DateParseable

  scope :base, ->{ select("shops.id, shops.km_id, shops.street_id, shops.shop_id, shops.registered_at, shops.shop_type, shops.name, shops.front_length, shops.starting_floor, shops.total_floors, shops.has_loading_area, shops.notes") }
  scope :base_count, ->{ select("COUNT(shops.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  
  validates :shop_id, length: { maximum: 100 }, presence: true
  validates :registered_at, presence: true
  validates :shop_type, presence: true, length: { maximum: 10 }   
  validates :name, presence: true, length { maximum: 100 }
  validates :front_length, numericality: true, presence: true
  validates :starting_floor, numericality: true, allow_blank: true 
  validates :total_floors, numericality: true, allow_blank: true
  validates :has_loading_area, presence:true, numericality: { only_integer: true }, inclusion: { in: self.boolean_int }
  validates :notes, length: { maximum: 300 }, allow_blank: true
  
  def registered_at=(val)
    write_attribute(:registered_at, date_time_val(val))
  end
  
end
