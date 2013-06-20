require 'yaml'

class Settings
  
  attr_accessor :config
  
  @@instance
  
  def initialize
    Settings.instance = self
    self.load_config
  end
  
  def self.load_file(path)
    require "#{Rails.root.to_s}#{path}"
  end
  
  def load_config
    self.config = {}
    config_src = "#{Rails.root.to_s}/config/fmx/fmx.yml"
    unless File.exist?(config_src)
      puts "Missing config file: #{config_src}"
      raise SystemExit.new(1)
    else
      data = YAML::load( File.read(config_src) )
      self.config = data["globals"]
      env_data = data[Rails.env]
      unless env_data.nil?
        self.config.deep_merge!(env_data)
      end
    end
  end
  
  def self.get(key = nil)
    instance = self.instance
    el = nil
    unless instance.nil?
      el = instance.config
      unless key.nil?
        parts = key.split(".")
        parts.each do |part|
          el = el[part]
          break if el.nil? 
        end
      end
    end
    el
  end
  
  def self.instance
    @@instance
  end
  
  def self.instance=(val)
    @@instance = val
  end
  
end

Settings.new