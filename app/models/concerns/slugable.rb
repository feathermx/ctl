module Slugable
  
  extend ActiveSupport::Concern
  
  included do
    
    scope :filter_by_slug, ->(slug){ where(slug: slug) }
    before_save :set_slug
    
    def set_slug
      self.slug = self.get_slug if self.slug.nil?
    end
    
    protected
    
    def get_slug
      self.slug = self.name.parameterize
    end
    
  end
  
  module ClassMethods
    
    def find_by_slug(slug)
      self.base.filter_by_slug(slug).first
    end
    
    def with_no_slug
      self.base.where("#{self.table_name}.slug IS NULL")
    end
    
    def update_slugs
      self.with_no_slug.each do |el|
        el.set_slug
        el.save
      end
    end
    
  end
  
  
end