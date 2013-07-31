class Backup::ParkingRestriction < ParkingRestriction
  
  include Backup::Backupable
  include Backup::BlockStreetable
  
  scope :backup_base, ->{ select('parking_restrictions.parking_restriction_type, parking_restrictions.day_of_week, parking_restrictions.starts_at, parking_restrictions.ends_at, parking_restrictions.parking_duration, parking_restrictions.notes').include_street.include_block }
  
  def as_json(opts = {})
    super(opts.merge(
        only: [:parking_restriction_type, :day_of_week, :starts_at, :ends_at, :parking_duration, :notes],
        methods: self.class.block_street_json
    ))
  end
  
  def starts_at=(val)
    write_attribute(:starts_at, val)
  end
  
  def ends_at=(val)
    write_attribute(:ends_at, val)
  end
  
  def day_of_week=(val)
    write_attribute(:day_of_week, val)
  end
  
  
end
