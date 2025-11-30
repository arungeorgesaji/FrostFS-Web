class MaintenanceController < ApplicationController
  def index
    @frostfs_path = ENV['FROSTFS_PATH'] || Rails.root.join('storage', 'frostfs')
  end

  def run
    @frostfs_path = ENV['FROSTFS_PATH'] || Rails.root.join('storage', 'frostfs')
    
    begin
      @fs = FrostFS::Filesystem.new(@frostfs_path.to_s)
      @result = @fs.seasonal_maintenance
      
      flash[:success] = "Maintenance completed successfully!"
    rescue => e
      flash[:error] = "Maintenance failed: #{e.message}"
    end
    
    redirect_to maintenance_path
  end
end
