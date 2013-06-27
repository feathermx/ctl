class Shop < ActiveRecord::FmxBase

  include BlockStreetable
  include DateParsable
  include Kmable
  
  module ShopType
    
    Grocery = 'A'
    Convinience = 'B'
    Gasoline = 'C'
    Clothing = 'D'
    Accomodation = 'E'
    Food = 'F'
    Drugstore = 'G'
    School = 'S'
    Other = 'O'
    
    List = {
      Grocery => {
        name: ''
      },
      Convinience => {
        name: ''
      },
      Gasoline => {
        name: ''
      },
      Clothing => {
        name: ''
      },
      Accomodation => {
        name: ''
      },
      Food => {
        name: ''
      },
      Drugstore => {
        name: ''
      },
      School => {
        name: ''
      },
      Other => {
        name: ''
      }
    }
    
    def self.keys
      @@keys ||= List.keys
    end
    
  end
  
  scope :base, ->{ select("shops.id, shops.km_id, shops.street_id, shops.shop_id, shops.registered_at, shops.shop_type, shops.name, shops.front_length, shops.starting_floor, shops.total_floors, shops.has_loading_area, shops.notes") }
  scope :base_count, ->{ select("COUNT(shops.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  scope :filter_by_shop_id, ->(shop_id){ where(shop_id: shop_id) }
  
  validates :shop_id, length: { maximum: 100 }, presence: true, uniqueness: true
  validates :registered_at, presence: true
  validates :shop_type, presence: true, length: { maximum: 10 }, inclusion: { in: ShopType.keys }
  validates :name, presence: true, length: { maximum: 100 }
  validates :front_length, numericality: true, presence: true
  validates :starting_floor, numericality: true, allow_blank: true 
  validates :total_floors, numericality: true, allow_blank: true
  validates :has_loading_area, presence:true, numericality: { only_integer: true }, inclusion: { in: self.boolean_int }
  validates :notes, length: { maximum: 300 }, allow_blank: true
  
  def self.find_by_shop_id(shop_id)
    self.base.filter_by_shop_id(shop_id).first
  end
  
  def r_at
    @r_at ||= ->{
      (self.registered_at.to_i * 1000) unless self.registered_at.nil?
    }.call
  end
  
  def registered_at=(val)
    write_attribute(:registered_at, date_time_val(val))
  end
  
  def shop_type=(val)
    write_attribute(:shop_type, upcase(val))
  end
  
end
