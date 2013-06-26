class Admin::TrafficCount < TrafficCount
  
  include MassInsertable
  
  scope :list, ->{ select("traffic_counts.id, traffic_counts.started_at, traffic_counts.ended_at").include_street.include_block }
  
  def as_json(opts = {})
    super(opts.merge(methods: [:s_at, :e_at]))
  end
  
  
  
  
end