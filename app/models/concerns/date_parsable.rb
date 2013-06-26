module DateParsable
  
  extend ActiveSupport::Concern
  
  
  included do
    
    protected
    
    def date_parsable_format
      @date_parsable_format ||= Settings.get('csv.date_format')
    end
    
    def date_time_val(val)
      begin
        val = Time.strptime("#{val} +0000", self.date_parsable_format)
      rescue
        val = nil
      end
      val
    end
    
  end
  
  
end