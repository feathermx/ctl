class Block < ActiveRecord::FmxBase
  
  module Status
    HasTracks = 1
    # TODO
  end
  
  scope :base, ->{ select("blocks.id, blocks.status, blocks.is_ready, blocks.city_id, blocks.name, blocks.description, blocks.comments, blocks.lat, blocks.lng, blocks.captured_at") }
  scope :base_count, ->{ select("COUNT(blocks.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  
  attr_protected :status, :is_ready, :city_id
  
  validates :city_id, :name, :lat, :lng, presence: true
  validates :city_id, numericality: { only_integer: true }
  validates :name, length: { in: 2..100 }
  validates :description, length: { in: 2..300 }, allow_blank: true
  validates :comments, length: { in: 2..300 }, allow_blank: true
  validates :lat, numericality: { only_integer: true }
  validates :lng, numericality: { only_integer: true }
  
  
end
