class Admin::Delivery < Delivery
  
  include MassInsertable
  
  scope :list, ->{ select("deliveries.id, deliveries.started_at, deliveries.ended_at").include_street.include_block }
  
  def as_json(opts = {})
    super(opts.merge(methods: [:s_at, :e_at]))
  end
  
end
