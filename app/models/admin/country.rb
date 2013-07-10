class Admin::Country < Country
  
  scope :list, ->{ select("countries.id, countries.city_count, countries.name, countries.extension") }
  
  def as_json(opts = {})
    super(opts.merge(methods: [:image_path]))
  end
  
  def list_elements(base)
    base.filter_by_country(self.id)
  end
  
  def find_city_by_id(id)
    Admin::City.base.filter_by_country(self.id).filter_by_id(id).first
  end
  
  
end
