class Admin::TrafficCount < TrafficCount
  
  scope :list, ->{ select("traffic_counts.id, traffic_counts.started_at, traffic_counts.ended_at").include_street.include_block }
  
  
  
end
