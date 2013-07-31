class Backup::Km < Km
  
  include Backup::Backupable
  
  scope :backup_base, ->{ select('kms.id, kms.city_id, kms.name, kms.description, kms.comments, kms.lat, kms.lng, kms.street_lat, kms.street_lng') }
  
  def self.restore(data)
    success = true
    km = self.from_backup(data["data"])
    unless km.save
      success = false
      puts "unable to restore km: #{km.errors.inspect}"
    else
      dependencies = data["dependencies"]
      self.backup_dependencies.each do |cls|
        key = cls.table_name
        el_data = dependencies[key]
        if !el_data.blank? && el_data.kind_of?(Array)
          el_data.each do |val|
            el = cls.from_backup(val)
            el.km_id = km.id
            unless el.save
              puts "unable to restore #{key}: #{el.errors.inspect}"
            end
            break unless success
          end
        end
      end
    end
    success
  end
  
  def dump_to(path)
    abs_path = "#{path}/#{self.id}.json"
    File.open(abs_path, 'w') do |f|
      f.write(self.json_backup.to_json)
    end
  end
  
  def json_backup
    @json_backup ||= {
      data: self,
      dependencies: self.json_dependencies
    }
  end
  
  def json_dependencies
    @json_dependencies ||= ->{
      list = {}
      self.class.backup_dependencies.each do |cls|
        list[cls.table_name] = cls.backup_base.filter_by_km(self.id)
      end
      list
    }.call
  end
  
  def as_json(opts = {})
    super(opts.merge(
        only: [:city_id, :name, :description, :comments, :lat, :lng, :street_lat, :street_lng]
    ))
  end
  
  def self.backup_dependencies
    @@backup_dependencies ||= [
      Backup::Track,
      Backup::TrafficCount,
      Backup::Shop,
      Backup::Delivery,
      Backup::StreetData,
      Backup::ParkingRestriction,
      Backup::TrafficDisruption
    ]
  end
  
  
  
end