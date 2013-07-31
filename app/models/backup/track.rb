class Backup::Track < Track
  
  include Backup::Backupable
  
  scope :backup_base, ->{ select('tracks.lat, tracks.lng, tracks.tracked_at') }
  
  def as_json(opts = {})
    super(opts.merge(
        only: [:lat, :lng, :tracked_at]
    ))
  end
  
  
  
end
