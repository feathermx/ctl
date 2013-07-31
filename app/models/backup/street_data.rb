class Backup::StreetData < StreetData
  
  include Backup::Backupable
  include Backup::BlockStreetable
  
  scope :backup_base, ->{ select('street_data.way, street_data.driving_lanes, street_data.bike_lanes, street_data.parking_lanes, street_data.public_transport_lanes, street_data.extra_crosswalks, street_data.width_of_sidewalks, street_data.transport_stop, street_data.has_loading_area, street_data.loading_area_length, street_data.has_parking_area, street_data.parking_area_length, street_data.parking_payment, street_data.notes').include_street.include_block }
  
  def as_json(opts = {})
    super(opts.merge(
        only: [:way, :driving_lanes, :bike_lanes, :parking_lanes, :public_transport_lanes, :extra_crosswalks, :width_of_sidewalks, :transport_stop, :has_loading_area, :loading_area_length, :has_parking_area, :parking_area_length, :parking_payment, :notes],
        methods: self.class.block_street_json
    ))
  end
  
  def way=(val)
    write_attribute(:way, val)
  end
  
  def transport_stop=(val)
    write_attribute(:transport_stop, val)
  end
  
  def parking_payment=(val)
    write_attribute(:parking_payment, val)
  end
  
  
  
end
