class Admin::Language < Language
  
  scope :list, ->{ select("languages.id, languages.name") }
  
  def self.select_list
    self.list.ascending.map do |el|
      [el.name, el.id]
    end
  end
  
  
end
