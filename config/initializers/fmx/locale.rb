module I18n
  
  def self.t(*args)
    self.translate(*args).html_safe
  end
  
end
