class Backup::TrafficCount < TrafficCount
  
  include Backup::Backupable
  include Backup::BlockStreetable
  
  scope :backup_base, ->{ select('traffic_counts.started_at, traffic_counts.ended_at, traffic_counts.cars, traffic_counts.taxis, traffic_counts.pickup_trucks, traffic_counts.articulated_trucks, traffic_counts.rigid_trucks, traffic_counts.vans, traffic_counts.buses, traffic_counts.bikes, traffic_counts.motorbikes, traffic_counts.pedestrians, traffic_counts.notes').include_street.include_block }
  
  def as_json(opts = {})
    super(opts.merge(
        only: [:started_at, :ended_at, :cars, :taxis, :pickup_trucks, :articulated_trucks, :rigid_trucks, :vans, :buses, :bikes, :motorbikes, :pedestrians, :notes],
        methods: self.class.block_street_json
    ))
  end
  
  def started_at=(val) 
    write_attribute(:started_at, val)
  end
  
  def ended_at=(val)
    write_attribute(:ended_at, val)
  end
  
  
end
