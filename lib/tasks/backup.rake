namespace :backup do
  
  desc 'dump backup'
  task dump: :environment do
    Settings.load_file('/lib/script/backup/dump.rb')
    Backup::Dump.new
  end
  
  desc 'load from backup'
  task :load, [:name] => :environment do |t, args|
    Settings.load_file('/lib/script/backup/loader.rb')
    Backup::Loader.new(args)
  end
  
  
end