module Backup::BlockStreetable
  
  extend ActiveSupport::Concern
  
  included do
    
    def block_research
      @block_research ||= self[:b_research]
    end
    
    def street_research
      @street_research ||= self[:s_research]
    end
    
  end
  
  module ClassMethods
    
    def block_street_json
      @@block_street_json ||= [:block_research, :street_research]
    end
    
  end
  
end