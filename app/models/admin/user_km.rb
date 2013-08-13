class Admin::UserKm < UserKm
  
  def self.user_multiselect_values(user_id)
    self.km_base.filter_by_user(user_id).map do |el|
      el.multiselect_val
    end
  end
  
  def multiselect_val
    @multiselect_val ||= { id: self[:km_id], name: self.km_full_name }
  end
  
  
end
