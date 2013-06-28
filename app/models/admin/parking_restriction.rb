class Admin::ParkingRestriction < ParkingRestriction
  
  include MassInsertable
  
  scope :list, ->{ select("parking_restrictions.id, parking_restrictions.starts_at, parking_restrictions.ends_at").include_street.include_block }
  
  def as_json(opts = {})
    super(opts.merge(methods: [:s_at, :e_at]))
  end
  
end
