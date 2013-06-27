class Admin::TrafficDisruption < TrafficDisruption
  
  include MassInsertable
  
  scope :list, ->{ select("traffic_disruptions.id, traffic_disruptions.started_at, traffic_disruptions.ended_at").include_street.include_block }
  
  def as_json(opts = {})
    super(opts.merge(methods: [:s_at, :e_at]))
  end
  
end