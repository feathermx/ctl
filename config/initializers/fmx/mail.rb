module Mail
  
  class Message
    
    def to_y
      hash = {}
      hash['headers'] = {}
      header.fields.each do |field|
        hash['headers'][field.name] = field.value
      end
      hash['delivery_handler'] = delivery_handler.to_s if delivery_handler
      hash['transport_encoding'] = transport_encoding.to_s
      special_variables = [:@header, :@delivery_handler, :@transport_encoding]
      if multipart?
        hash['multipart_body'] = []
        body.parts.map { |part| hash['multipart_body'] << part.to_yaml }
        special_variables.push(:@body, :@text_part, :@html_part)
      end
      (instance_variables.map(&:to_sym) - special_variables).each do |var|
        hash[var.to_s] = instance_variable_get(var)
      end
      hash["@body"] = Base64.encode64(self.body.raw_source)
      YAML.dump(hash)
    end
    
    def self.from_y(data)
      hash = YAML.load(data)
      body = Base64.decode64(hash["@body"])
      hash["@body"] = nil
      el = self.new(hash)
      el.body = body
      ActionMailer::Base.wrap_delivery_behavior el
      el
    end
    
    
  end
  
end