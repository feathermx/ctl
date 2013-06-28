module DateTimeable
  
  extend ActiveSupport::Concern
  
  class DateTimeField
    
    attr_accessor :name, :required, :date_delim, :date_order, :parent, :date, :time
    
    def initialize(args = {})
      opts = {
        required: false,
        date_delim: '/',
        date_order: 'mdY'
      }
      opts.merge!(args)
      opts.each do |name, value|
        send("#{name}=", value)
      end
    end
    
    def date=(val)
      @date = self.date_str(val)
      self.set_date_time_field
    end
    
    def time_regex
      @time_regex ||= %r{^(20|21|22|23|[01]\d|\d)(([:.][0-5]*\d){1,2})$}
    end
    
    def time=(val)
      unless val.blank?
        matches = self.time_regex.match(val)
        unless matches.nil?
          @time = val
          self.set_date_time_field
        end
      end
    end
    
    def set_date_time_field
      unless self.date.nil? || self.time.nil?
        date_time = "#{self.date} #{self.time} +00:00"
        begin
          self.parent.send("#{self.name}=", Time.parse(date_time))
        rescue
          puts "--------------------"
          puts "--------------------"
          puts "--------------------"
          puts date_time
          puts "--------------------"
          puts "--------------------"
          puts "--------------------"
        end
      end
    end
    
    def date_str(val)
      res = nil
      unless val.blank?
        date = {}
        parts = val.split(self.date_delim)
        if parts.length == 3
          tmp = {}
          parts.each_with_index do |part, i|
            key = self.date_order[i]
            part = part.to_i
            part = part + 2000 if key == "y"
            tmp[self.date_order[i]] = part
          end
          year = tmp["y"] || tmp["Y"]
          res = "#{year}-#{tmp["m"]}-#{tmp["d"]}"
        end  
      end
      res
    end
    
    def date_field
      @date_field ||= "#{self.name}_date"
    end
    
    def time_field
      @time_field ||= "#{self.name}_time"
    end
    
    def set_parent
      obj = self
      date_setter = "#{self.date_field}="
      time_setter = "#{self.time_field}="
      self.parent.class.send :define_method, date_setter do |val|
        obj.date = val
      end
      self.parent.class.send :define_method, time_setter do |val|
        obj.time = val
      end
    end
    
    def validate
      if self.required
        date_time = self.parent.send(self.name)
        if date_time.nil?
          err_msg = I18n.t('activerecord.errors.messages.invalid').html_safe
          self.parent.errors.add(self.date_field, err_msg) if self.date.nil?
          self.parent.errors.add(self.time_field, err_msg) if self.time.nil?
        end
      end
    end
    
    
  end
  
  included do
    
    validate :validate_date_time_fields
    after_initialize :set_date_time_fields
    
    def initialize(attributes = {})
      self.set_date_time_fields
      super
    end
    
    protected
    
    #required
    def date_time_fields
      raise NotImplementedError
    end
    
    def set_date_time_fields
      if @setted_date_time_fields.nil?
        @setted_date_time_fields = true
        self.date_time_fields.each do |field|
          field.parent = self
          field.set_parent
        end
      end
    end
    
    def validate_date_time_fields
      self.date_time_fields.each do |field|
        field.validate
      end
    end
    
  end
  
  
end