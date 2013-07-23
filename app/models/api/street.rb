class Api::Street < Street
  
  module Json
    Default = {}
    Chart = {
      only: [:research_id, :public_meter_length, :dedicated_meter_length]
    }
  end
  
  scope :api_chart_base, ->{ select('streets.research_id, streets.public_meter_length, streets.dedicated_meter_length').chart_order.with_data.research_ascending }
  scope :chart_order, ->{ order('streets.public_meter_length DESC, streets.dedicated_meter_length DESC')  }
  scope :api_map_base, ->{ select('streets.research_id, streets.public_meter_length, streets.dedicated_meter_length, streets.lat1, streets.lng1, streets.lat2, streets.lng2').with_location }
  
  def self.json_display
    @@json_display ||= Json::Default
  end
  
  def self.json_display=(val)
    @@json_display = val
  end
  
  def as_json(opts = {})
    super(opts.merge(self.class.json_display))
  end
  
  def self.map_data(km_id)
    data = nil
    lang_base = 'app.model.street.type'
    public_data = []
    dedicated_data = []
    self.api_map_base.filter_by_km(km_id).each do |el|
      public_data.push({
        mts: el.research_id,
        lat: el.lat1,
        lng: el.lng1
      })
      dedicated_data.push({
        mts: el.research_id,
        lat: el.lat2,
        lng: el.lng2
      })
    end
    data = {
      public_data: {
        name: I18n.t("#{lang_base}.public").html_safe,
        elements: public_data
      },
      dedicated_data: {
        name: I18n.t("#{lang_base}.dedicated").html_safe,
        elements: dedicated_data
      }
    }
    data
  end
  
  
end
