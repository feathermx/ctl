class Admin::PerformanceResult < PerformanceResult
  
  SecDecimals = 2
  
  scope :list_base, ->{ select('performance_results.id, performance_results.technology, performance_results.total_time, performance_results.created_at, kms.name AS km_name') }
  scope :list, ->{ list_base.with_km }

  def as_json(opts = {})
    super(opts.merge(methods: [:c_at]))
  end
  
  def admin_general_time
    @admin_general_time ||= self.total_time_secs.round(SecDecimals)
  end
  
  def admin_street_time
    @admin_streets_time ||= self.streets_time_secs.round(SecDecimals)
  end

end
