module DateStringable
  
  extend ActiveSupport::Concern
  
  included do
    
    def date_str(val, del, order = "mdY")
      res = nil
      unless val.blank?
        date = {}
        parts = val.split(del)
        if parts.length == 3
          tmp = {}
          parts.each_with_index do |part, i|
            key = order[i]
            part = part.to_i
            part = part + 2000 if key == "y"
            tmp[order[i]] = part
          end
          res = "#{tmp["y"]}-#{tmp["m"]}-#{tmp["d"]}"
        end  
      end
      res
    end
    
  end
  
end