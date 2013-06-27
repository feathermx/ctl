module ActiveRecord
  
  class FmxBase < Base
    
    self.abstract_class = true
    attr_protected :id, :created_at, :updated_at
    
    module OrderType
      Asc = 0
      Desc = 1
      AscName = 'asc'
      DescName = 'desc'
      List = { Asc => AscName, Desc => DescName }
    end
    
    module Regex
      Mail = %r{\A(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})\Z}i
      Url = %r{\A(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])\Z}i
      Ip = %r{\A(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\Z}
    end
    
    def self.apply_limit_order(params, show=nil)
      self.apply_order(params, show).apply_limit(params, show)
    end
    
    def self.apply_order(params, show=nil)
      instance = self
      order = params[:order]
      unless order.nil? || order.kind_of?(Array)
        field = order[:field]
        unless field.blank?
          by = order[:by].to_i
          order_type = OrderType::List[by]
          order_type = OrderType::AscName if order_type.nil?
          instance = instance.order("#{field} #{order_type}")
        end
      end
      instance
    end
    
    def self.apply_limit(params, show=nil)
      page = params[:page].to_i
      page = 0 if page < 0
      res = self
      res = res.limit(show).offset(page * show) unless show.nil?
      res
    end
    
    def self.find_by_id(id)
      self.base.filter_by_id(id).first
    end
    
    def time_val(val)
      self.class.time_val(val)
      #Time.at(self.class.timestamp_val(val))
    end
    
    def upcase(val)
      val.upcase unless val.blank?
    end
    
    protected
    
    def self.base
      raise NotImplementedError
    end
    
    def self.count
      raise NotImplementedError
    end
    
    def cgi_val(val)
      CGI.unescape(val) unless val.nil?
    end
    
    def self.time_val(val)
      res = self.timestamp_val(val)
      res = Time.at(res) unless res.nil?
      res
    end
    
    def self.timestamp_val(val)
      res = nil
      res = (val.to_i / 1000) unless val.blank?
      res
    end
    
    def self.boolean_int
      (0..1)
    end
    
  end
  
end