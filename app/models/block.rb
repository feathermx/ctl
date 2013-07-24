class Block < ActiveRecord::FmxBase
  
  include Researchable
  
  scope :base, ->{ select("blocks.id, blocks.km_id, blocks.research_id") }
  scope :base_count, ->{ select("COUNT(blocks.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  scope :filter_by_km, ->(km_id){ where(km_id: km_id) }
  
  validates :km_id, presence: true
  validates :research_id, uniqueness: { scope: :km_id }
  
end
