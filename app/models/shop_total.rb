class ShopTotal < ActiveRecord::FmxBase
  
  scope :base, ->{ select('shop_totals.id, shop_totals.km_id, shop_totals.shop_type, shop_totals.total') }
  scope :base_count, ->{ select('COUNT(shop_totals.id) as num') }
  scope :filter_by_km, ->(km_id){ where(km_id: km_id) }
  scope :filter_by_id, ->{ where(id: id) }
  
  attr_protected :km_id, :shop_type, :total
  
  validates :km_id, :shop_type, :total, presence: true
  validates :km_id, numericality: true
  validates :shop_type, length: { maximum: 10 }, inclusion: { in: Shop::ShopType.keys }
  validates :total, numericality: { only_integer: true }
  
  def self.generate(type, km_id)
    el = self.new
    el.km_id = km_id
    el.shop_type = type
    el.total = Shop.total_for_type(type, km_id)
    el
  end
  
end
