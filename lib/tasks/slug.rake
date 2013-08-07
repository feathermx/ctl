namespace :slug do
  
  desc 'set missing slugs for countries, cities & kms'
  task update: :environment do
    Country.update_slugs
    City.update_slugs
    Km.update_slugs
  end
  
  
end