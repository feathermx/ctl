module Researchable
  
  extend ActiveSupport::Concern
  
  included do
    
    attr_protected :research_id
    
    scope :filter_by_research, ->(research_id){ where(research_id: research_id) }
    validates :research_id, presence: true, numericality: { only_integer: true }, uniqueness: true
    
  end
  
  module ClassMethods
    
    def find_by_research(research_id)
      self.base.filter_by_research(research_id).first
    end
    
    def generate(research_id, opts = {})
      el = self.new
      puts opts.inspect
      opts.each do |name, value|
        el.send("#{name}=", value)
      end
      el.research_id = research_id
      el
    end
    
    def find_or_generate(research_id, opts={})
      el = self.find_by_research(research_id)
      if el.nil?
        el = self.generate(research_id, opts)
        el = nil unless el.save
      end
      el
    end
    
  end
  
end