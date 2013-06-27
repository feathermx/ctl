module Kmable
  
  extend ActiveSupport::Concern
  
  included do
    
    scope :filter_by_km, ->(km_id){ where(km_id: km_id) }
    
    attr_protected :km_id
    
    validates :km_id, presence: true, numericality: { only_integer: true }
    
    after_create :km_after_create
    before_destroy :km_before_destroy
    
    
    
    def km
      @km ||= Km.find_by_id(self.km_id)
    end
    
    def km_count_field
      @km_count_field ||= "#{self.class.table_name}_count"
    end
    
    def km_after_create
      curr_count = self.km.send(self.km_count_field).to_i
      self.km.send("#{self.km_count_field}=", curr_count + 1)
      self.km.save
    end
    
    def km_before_destroy
      curr_count = self.km.send(self.km_count_field).to_i
      self.km.send("#{self.km_count_field}=", curr_count - 1)
      self.km.save
    end
    
    
  end
  
  
end