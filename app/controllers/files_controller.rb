class FilesController < ApplicationController
  def index
    @frostfs_path = ENV['FROSTFS_PATH'] || Rails.root.join('storage', 'frostfs')
    
    FileUtils.mkdir_p(@frostfs_path)
    
    begin
      @fs = FrostFS::Filesystem.new(@frostfs_path.to_s)
      @file_count = @fs.total_file_count
      @stats = @fs.state_stats
    rescue => e
      @error = e.message
    end
  end
end
