module BlockStreetable
  
  extend ActiveSupport::Concern
  
  included do
    
    attr_protected :street_id, :km_id
    attr_accessor :street_research, :block_research
    
    
    
  end
  
  
end