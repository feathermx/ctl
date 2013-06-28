module DateParsable
  
  extend ActiveSupport::Concern
  
  included do
    
    protected
    
    def date_parsable_format
      @date_parsable_format ||= Settings.get('csv.date_format')
    end
    
    def time_parsable_format
      @time_parsable_format ||= Settings.get('csv.time_format')
    end
    
    def date_time_val(val)
      self.parse_date(val, self.date_parsable_format)
    end
    
    def time_val(val)
      self.parse_date(val, self.time_parsable_format)
    end
    
    def parse_date(val, format)
      begin
        val = Time.strptime("#{val} +0000", format)
      rescue
        val = nil
      end
      val
    end
    
  end
  
  
end