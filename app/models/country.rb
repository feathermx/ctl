class Country < ActiveRecord::FmxBase
  
  include Uploadable
  
  module Image
    Width = 18
    Height = 18
  end
  
  scope :base, ->{ select("countries.id, countries.city_count, countries.name, countries.extension") }
  scope :base_count, ->{ select("COUNT(countries.id) as num") }
  scope :filter_by_id, ->(id){ where(id: id) }
  
  attr_protected :city_count, :extension
  
  validates :name, presence: true
  validates :name, length: { in: 2..100 }, uniqueness: true
  
  def cities
    @cities ||= City.base.filter_by_country(self.id)
  end
  
  def image_path
    @image_path ||= ->{
      img = 'defaults/country.png'
      img = self.image_url unless self.extension.nil?
      img
    }.call
  end
  
  protected
  
  def upload_fields
    @upload_fields ||= [
      UploadField.generate(name: 'image', ext_field: :extension, required: false)
    ]
  end
  
  
end