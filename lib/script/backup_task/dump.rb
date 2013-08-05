module BackupTask
  
  class Dump
    
    def initialize(args={})
      args.each do |name, value|
        send("#{name}=", value)
      end
      self.dump
    end
    
    protected
    
    def dump
      puts 'creating backup...'
      self.create_dir
      self.dump_kms
      puts "backup saved to: #{self.dir_path}"
    end
    
    def dump_kms
      Backup.km_cls.backup_base.each do |km|
        km.dump_to(self.dir_path)
      end
    end
    
    def create_dir
      Dir.mkdir(self.dir_path)
    end
    
    def dir_name
      @dir_name ||= ->{
        now = Time.now
        format = self.backup.file_format
        now.strftime format
      }.call
    end
    
    def dir_path
      @dir_path ||= "#{self.backup.dir}/#{self.dir_name}"
    end
    
    def backup
      @backup ||= ->{
        Settings.load_file('/lib/script/backup_task/backup.rb')
        Backup.new
      }.call
    end
    
  end
  
end