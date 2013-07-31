module Backup
  
  class Loader
    
    attr_accessor :name
    
    def initialize(args)
      args.each do |name, value|
        send("#{name}=", value)
      end
      self.load
    end
    
    protected
    
    def load
      if self.name.blank?
        puts "missing backup name arg"
      elsif !File.exists?(self.dir_path)
        puts "backup not found: #{self.dir_path}"
      elsif !File.directory?(self.dir_path)
        puts "invalid backup. not a directory: #{self.dir_path}"
      else
        puts 'restoring...'
        self.kms_transaction
      end
    end
    
    def kms_transaction
      ActiveRecord::Base.transaction do
        success = self.destroy_kms && self.load_kms
        if success
          puts "restored from #{self.dir_path}"
        else
          raise ActiveRecord::Rollback
        end
      end
    end
    
    def destroy_kms
      self.km_cls.base.each do |el|
        el.destroy
      end
      true
    end
    
    def load_kms
      success = true
      Dir.entries(self.dir_path).each do |file_name|
        unless Backup::IgnoreFiles.include?(file_name)
          data = nil
          begin
            abs_path = "#{self.dir_path}/#{file_name}"
            file = File.open(abs_path)
            data = JSON.parse(file.read)
            file.close
          rescue Exception => e
            puts "Unable to read file #{file_name}: #{e}"
            success = false
          end
          unless data.nil?
            success = self.km_cls.restore(data)
          end
        end
        break unless success
      end
      success
    end
    
    def km_cls
      @km_cls ||= Backup::Km
    end
    
    def dir_path
      @dir_path ||= "#{self.backup.dir}/#{self.name}"
    end
    
    def backup
      @backup ||= ->{
        Settings.load_file('/lib/script/backup/backup.rb')
        Backup.new
      }.call
    end
    
    
  end
  
end