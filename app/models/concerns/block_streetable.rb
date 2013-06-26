module BlockStreetable
  
  extend ActiveSupport::Concern
  
  included do
    
    attr_protected :street_id, :km_id
    attr_accessor :street_research, :block_research
    
    validates :street_research, numericality: { only_integer: true } , presence: true
    validates :block_research, numericality: { only_integer: true }, presence: true
    
    before_save :block_streetable_on_before_save
    
    def block_streetable_on_before_save
      unless self.street_research.nil? || self.block_research.nil?
        block = Block.find_or_generate(self.block_research)
        unless block.nil?
          street = Street.find_or_generate(self.street_research, { block_id: block.id })
          self.street_id = street.id unless street.nil?
        end
      end
    end
    
  end
  
  
end