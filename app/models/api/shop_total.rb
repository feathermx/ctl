class Api::ShopTotal < ShopTotal
  
  module Json
    Default = {}
    Chart = {
      methods: [:s_type_name],
      only: [:shop_type, :total]
    }
  end
  
  scope :api_chart_base, ->{ select('shop_totals.shop_type, shop_totals.total').with_data }
  
  def self.json_display
    @@json_display ||= Json::Default
  end
  
  def self.json_display=(val)
    @@json_display = val
  end
  
  def as_json(opts = {})
    super(opts.merge(self.class.json_display))
  end
  
  
end
