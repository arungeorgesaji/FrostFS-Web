class DashboardController < ApplicationController
  def index
    @frostfs_path = ENV['FROSTFS_PATH'] || Rails.root.join('storage', 'frostfs')
    @recent_activities = []  

    FileUtils.mkdir_p(@frostfs_path)

    begin
      @fs = FrostFS::Filesystem.new(@frostfs_path.to_s)
      create_sample_files_if_empty(@fs)

      @file_count = @fs.total_file_count
      @stats = @fs.state_stats
      @recent_activities = FileActivity.recent_activities(@fs, 5)

    rescue => e
      @error = e.message
      
      @file_count = 0
      @stats = {
        active: 0,
        chilled: 0,
        frozen: 0,
        deep_frozen: 0
      }
      @recent_activities ||= []
    end
  end
end
