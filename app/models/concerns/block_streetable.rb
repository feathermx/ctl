module BlockStreetable
  
  extend ActiveSupport::Concern
  
  included do
    
    scope :street_base, ->{ select("streets.research_id as s_research") }
    scope :block_base, ->{ select("blocks.research_id as b_research") }
    
    attr_protected :street_id, :km_id
    attr_accessor :street_research, :block_research
    
    validates :street_research, numericality: { only_integer: true } , presence: true, if: :new_record?
    validates :block_research, numericality: { only_integer: true }, presence: true, if: :new_record?
    
    before_save :block_streetable_on_before_save
    
    def block_streetable_on_before_save
      unless self.street_research.nil? || self.block_research.nil?
        params = { km_id: self.km_id }
        block = Block.find_or_generate(self.block_research, params)
        unless block.nil?
          street = Street.find_or_generate(self.street_research, params.merge(block_id: block.id))
          self.street_id = street.id unless street.nil?
        end
      end
    end
    
    def street
      @street ||= Street.base.find_by_id(self.street_id)
    end
    
    def block
      @block ||= Block.base.find_by_id(self.street.block_id)
    end
    
  end
  
  module ClassMethods
    
    def include_street
      self.street_base.joins("JOIN streets ON streets.id = #{self.table_name}.street_id")
    end
    
    def include_block
      self.block_base.joins("JOIN blocks ON blocks.id = streets.block_id")
    end
    
  end
  
  
  
end