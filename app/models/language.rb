class Language < ActiveRecord::FmxBase
  
  scope :base, ->{ select("languages.id, languages.name") }
  scope :base_count, ->{ select("COUNT(languages.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  scope :ascending, ->{ order("languages.name ASC") }
  
  validates :name, presence: true
  validates :name, length: { in: 2..100 }, uniqueness: true
  
  
end