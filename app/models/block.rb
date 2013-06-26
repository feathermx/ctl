class Block < ActiveRecord::FmxBase
  
  include Researchable
  
  scope :base, ->{ select("blocks.id, blocks.km_id, blocks.research_id") }
  scope :base_count, ->{ select("COUNT(blocks.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  
  validates :km_id, presence: true
  
  
end
