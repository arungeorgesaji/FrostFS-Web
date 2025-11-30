class ThermalController < ApplicationController
  def index
    @frostfs_path = ENV['FROSTFS_PATH'] || Rails.root.join('storage', 'frostfs')
    
    begin
      @fs = FrostFS::Filesystem.new(@frostfs_path.to_s)
      @heat_data = @fs.thermal_imaging
      
      @sorted_files = @heat_data.sort_by { |_, data| -data[:score] }.first(50) 
      
    rescue => e
      @error = e.message
    end
  end
end
