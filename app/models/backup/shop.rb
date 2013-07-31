class Backup::Shop < Shop
  
  include Backup::Backupable
  include Backup::BlockStreetable
  
  scope :backup_base, ->{ select('shops.shop_id, shops.registered_at, shops.shop_type, shops.name, shops.front_length, shops.starting_floor, shops.total_floors, shops.has_loading_area, shops.notes').include_street.include_block }
  
  def as_json(opts = {})
    super(opts.merge(
        only: [:shop_id, :registered_at, :shop_type, :name, :front_length, :starting_floor, :total_floors, :has_loading_area, :notes],
        methods: self.class.block_street_json
    ))
  end
  
  def registered_at=(val)
    write_attribute(:registered_at, val)
  end
  
  def shop_type=(val)
    write_attribute(:shop_type, val)
  end
  
  
  
end
