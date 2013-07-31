class Backup::TrafficDisruption < TrafficDisruption
  
  include Backup::Backupable
  include Backup::BlockStreetable
  
  scope :backup_base, ->{ select('traffic_disruptions.delivery_key, traffic_disruptions.source, traffic_disruptions.vehicle_type, traffic_disruptions.length_type, traffic_disruptions.started_at, traffic_disruptions.ended_at, traffic_disruptions.more_than_five_secs, traffic_disruptions.disruption_type, traffic_disruptions.blocked_lanes, traffic_disruptions.vehicles_affected, traffic_disruptions.slowed_or_stop, traffic_disruptions.entered_car, traffic_disruptions.notes').include_street.include_block }
  
  def as_json(opts = {})
    super(opts.merge(
        only: [:delivery_key, :source, :vehicle_type, :length_type, :started_at, :ended_at, :more_than_five_secs, :disruption_type, :blocked_lanes, :vehicles_affected, :slowed_or_stop, :entered_car, :notes],
        methods: self.class.block_street_json
    ))
  end
  
  def started_at=(val) 
    write_attribute(:started_at, val)
  end
  
  def ended_at=(val) 
    write_attribute(:ended_at, val)
  end
  
  def source=(val)
    write_attribute(:source, val)
  end
  
  def disruption_type=(val)
    write_attribute(:disruption_type, val)
  end
  
  def slowed_or_stop=(val)
    write_attribute(:slowed_or_stop, val)
  end
  
  
  
end
