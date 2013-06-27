class Admin::StreetData < StreetData
  
  include MassInsertable
  
  scope :list, ->{ select("street_data.id, street_data.created_at").include_street.include_block }
  
  def as_json(opts = {})
    super(opts.merge(methods: [:c_at]))
  end
  
end
