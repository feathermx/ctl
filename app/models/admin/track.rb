class Admin::Track < Track
  
  include MassInsertable
  include DateTimeable
  
  scope :list, ->{ select("tracks.id, tracks.lat, tracks.lng, tracks.tracked_at") }
  
  attr_protected :tracked_at
  
  def lng=(val)
    num = val.to_f
    val = (num * -1) unless num == 0
    write_attribute(:lng, val)
  end
  
  def as_json(opts = {})
    super(opts.merge(methods: [:t_at]))
  end
  
  protected
  
  def date_time_fields
    @date_time_fields ||= [
      DateTimeField.new(name: 'tracked_at', required: true, date_order: 'Ymd')
    ]
  end
  
end