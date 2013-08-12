class Backup::Km < Km
  
  include Backup::Backupable
  
  scope :backup_base, ->{ select('kms.id, kms.name, kms.description, kms.comments, kms.lat, kms.lng, kms.street_lat, kms.street_lng').with_city_slug.with_country_slug }
  scope :with_city_slug, ->{ select('cities.slug as city_slug').joins('JOIN cities ON cities.id = kms.city_id') }
  scope :with_country_slug, ->{ select('countries.slug as country_slug').joins('JOIN countries ON countries.id = cities.country_id') }
  
  def self.restore(data)
    success = true
    km = nil
    km_data = data['data']
    slugs = {
      country: km_data.delete('country_slug'),
      city: km_data.delete('city_slug')
    }
    country = Country.find_by_slug(slugs[:country])
    if country.nil?
      success = false
      puts "Country not found: #{slugs[:country]}"
    else
      city = City.base.filter_by_country(country.id).filter_by_slug(slugs[:city]).first
      if city.nil?
        success = false
        puts "City not found: #{slugs[:country]}, #{slugs[:city]}"
      else
        km_data['city_id'] = city.id
      end
    end
    km = self.from_backup(km_data) if success
    if !success || km.nil? || !km.save
      success = false
      puts "unable to restore km: #{km.errors.inspect}" unless km.nil?
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
  
  def country_slug
    @country_slug ||= self[:country_slug]
  end
  
  def city_slug
    @city_slug ||= self[:city_slug]
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
        only: [:name, :description, :comments, :lat, :lng, :street_lat, :street_lng],
        methods: [:city_slug, :country_slug]
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