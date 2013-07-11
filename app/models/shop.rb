class Shop < ActiveRecord::FmxBase

  include BlockStreetable
  include DateParsable
  include Kmable
  include Localizable
  
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
    Unknown = 'U'
    
    KioskGrocery = "K#{Grocery}"
    KioskConvinience = "K#{Convinience}"
    KioskGasoline = "K#{Gasoline}"
    KioskClothing = "K#{Clothing}"
    KioskAccomodation = "K#{Accomodation}"
    KioskFood = "K#{Food}"
    KioskDrugstore = "K#{Drugstore}"
    KioskSchool = "K#{School}"
    KioskOther = "K#{Other}"
    KioskUnknown = "K#{Unknown}"
    
    List = {
      Grocery => {
        name: I18n.t('app.model.shop.shop_type.grocery')
      },
      Convinience => {
        name: I18n.t('app.model.shop.shop_type.convinience')
      },
      Gasoline => {
        name: I18n.t('app.model.shop.shop_type.gasoline')
      },
      Clothing => {
        name: I18n.t('app.model.shop.shop_type.clothing')
      },
      Accomodation => {
        name: I18n.t('app.model.shop.shop_type.accomodation')
      },
      Food => {
        name: I18n.t('app.model.shop.shop_type.food')
      },
      Drugstore => {
        name: I18n.t('app.model.shop.shop_type.drugstore')
      },
      School => {
        name: I18n.t('app.model.shop.shop_type.school')
      },
      Other => {
        name: I18n.t('app.model.shop.shop_type.other')
      },
      Unknown => {
        name: I18n.t('app.model.shop.shop_type.unknown')
      },
      KioskGrocery => {
        name: I18n.t('app.model.shop.shop_type.kiosk_grocery')
      },
      KioskConvinience => {
        name: I18n.t('app.model.shop.shop_type.kiosk_convinience')
      },
      KioskGasoline => {
        name: I18n.t('app.model.shop.shop_type.kiosk_gasoline')
      },
      KioskClothing => {
        name: I18n.t('app.model.shop.shop_type.kiosk_clothing')
      },
      KioskAccomodation => {
        name: I18n.t('app.model.shop.shop_type.kiosk_accomodation')
      },
      KioskFood => {
        name: I18n.t('app.model.shop.shop_type.kiosk_food')
      },
      KioskDrugstore => {
        name: I18n.t('app.model.shop.shop_type.kiosk_drugstore')
      },
      KioskSchool => {
        name: I18n.t('app.model.shop.shop_type.kiosk_school')
      },
      KioskOther => {
        name: I18n.t('app.model.shop.shop_type.kiosk_other')
      },
      KioskUnknown => {
        name: I18n.t('app.model.shop.shop_type.kiosk_unknown')
      }
    }
    
    def self.keys
      @@keys ||= List.keys
    end
    
  end
  
  module LoadingAreaType
    
    OffStreet = 0
    OnStreet = 1
    
    List = {
      OffStreet => {
        name: I18n.t('app.model.shop.loading_area_type.off_street')
      },
      OnStreet => {
        name: I18n.t('app.model.shop.loading_area_type.on_street')
      }
    }
    
    def self.keys
      @@keys ||= List.keys
    end
    
  end
  
  scope :base, ->{ select("shops.id, shops.km_id, shops.street_id, shops.shop_id, shops.registered_at, shops.shop_type, shops.name, shops.front_length, shops.starting_floor, shops.total_floors, shops.has_loading_area, shops.loading_area_type, shops.notes, shops.lat, shops.lng") }
  scope :base_count, ->{ select("COUNT(shops.id) as num") }
  scope :track_base, ->{ select("shops.street_id") }
  scope :filter_by_id, ->(id){ where(id: id) }
  scope :filter_by_shop_id, ->(shop_id){ where(shop_id: shop_id) }
  scope :filter_after, ->(time){ where('shops.registered_at >= ?', time).order('shops.registered_at ASC') }
  scope :filter_before, ->(time){ where('shops.registered_at <= ?', time).order('shops.registered_at ASC') }
  
  validates :shop_id, length: { maximum: 100 }, presence: true, uniqueness: true
  validates :registered_at, presence: true
  validates :shop_type, presence: true, length: { maximum: 10 }, inclusion: { in: ShopType.keys }
  validates :name, presence: true, length: { maximum: 100 }
  validates :front_length, numericality: true, allow_blank: true
  validates :starting_floor, numericality: true, allow_blank: true 
  validates :total_floors, numericality: true, allow_blank: true
  validates :has_loading_area, presence: true, numericality: { only_integer: true }, inclusion: { in: self.boolean_int }
  validates :loading_area_type, presence: true, numericality: { only_integer: true }, inclusion: { in: LoadingAreaType.keys }
  validates :notes, length: { maximum: 300 }, allow_blank: true
  
  def self.find_for_track(km_id)
    self.track_base.filter_by_km(km_id)
  end
  
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
  
  protected
  
  def location_field
    @location_field ||= "registered_at"
  end
  
end
