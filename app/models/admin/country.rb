class Admin::Country < Country
  
  scope :list, ->{ select("countries.id, countries.city_count, countries.name") }
  
  def list_elements(base)
    base.filter_by_country(self.id)
  end
  
  def find_city_by_id(id)
    Admin::City.base.filter_by_country(self.id).filter_by_id(id).first
  end
  
  
end
