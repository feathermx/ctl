namespace :backup do
  
  desc 'dump backup'
  task dump: :environment do
    Settings.load_file('/lib/script/backup_task/dump.rb')
    BackupTask::Dump.new
  end
  
  desc 'load from backup'
  task :load, [:name] => :environment do |t, args|
    Settings.load_file('/lib/script/backup_task/loader.rb')
    BackupTask::Loader.new(args)
  end
  
  
end