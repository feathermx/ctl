class Admin::Shop < Shop
  
  include MassInsertable
  
  scope :list, ->{ select("shops.id, shops.shop_id, shops.registered_at").include_street.include_block }
  
  def as_json(opts = {})
    super(opts.merge(methods: [:r_at]))
  end
  
  
end
