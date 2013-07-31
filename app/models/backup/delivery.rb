class Backup::Delivery < Delivery
  
  include Backup::Backupable
  include Backup::BlockStreetable
  
  scope :backup_base, ->{ select('deliveries.delivery_key, deliveries.started_at, deliveries.ended_at, deliveries.vehicle_type, deliveries.delivering_company, deliveries.product_delivered, deliveries.refrigerated_vehicle, deliveries.boxes_delivered, deliveries.delivery_type, deliveries.with_equipment, deliveries.number_of_trips, deliveries.distance_to_shop, deliveries.is_out_of_segment, deliveries.shops_served, deliveries.notes').include_shop.include_street.include_block }
  scope :include_shop, ->{ joins('JOIN shops ON shops.id = deliveries.shop_id').select('shops.shop_id as shop_id') }
  
  def as_json(opts = {})
    super(opts.merge(
        only: [:shop_id, :delivery_key, :started_at, :ended_at, :vehicle_type, :delivering_company, :product_delivered, :refrigerated_vehicle, :boxes_delivered, :delivery_type, :with_equipment, :number_of_trips, :distance_to_shop, :is_out_of_segment, :shops_served, :notes],
        methods: self.class.block_street_json
    ))
  end
  
  def started_at=(val)
    write_attribute(:started_at, val)
  end
  
  def ended_at=(val)
    write_attribute(:ended_at, val)
  end
  
  def delivery_type=(val)
    write_attribute(:delivery_type, val)
  end
  
end
