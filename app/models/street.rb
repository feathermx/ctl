class Street < ActiveRecord::FmxBase
  
  include Researchable
  
  scope :base, ->{ select("streets.id, streets.km_id, streets.block_id, streets.research_id") }
  scope :base_count, ->{ select("COUNT(streets.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  
  validates :km_id, :block_id, presence: true
  validates :km_id, numericality: { only_integer: true }
  validates :block_id, numericality: { only_integer: true }
  
  
end