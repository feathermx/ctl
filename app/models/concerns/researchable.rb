module Researchable
  
  extend ActiveSupport::Concern
  
  included do
    
    scope :filter_by_research, ->(research_id){ where(research_id: research_id) }
    validates :research_id, presence: true, numericality: { only_integer: true }, uniqueness: true
    
  end
  
  module ClassMethods
    
    def find_by_research(research_id)
      self.base.filter_by_research(research_id).first
    end
    
  end
  
end