class FileActionsController < ApplicationController
  def freeze
    file_path = params[:path]
    
    begin
      fs = FrostFS::Filesystem.new(frostfs_path)
      fs.state_manager.force_state(file_path, :frozen, 'web_interface')
      flash[:success] = "File frozen: #{file_path}"
    rescue => e
      flash[:error] = "Failed to freeze file: #{e.message}"
    end
    
    redirect_back fallback_location: files_path
  end

  def thaw
    file_path = params[:path]
    
    begin
      fs = FrostFS::Filesystem.new(frostfs_path)
      result = fs.thaw_file(file_path)
      
      if result[:success]
        flash[:success] = "File thawed: #{file_path}"
      else
        flash[:error] = "Failed to thaw file: #{result[:error]}"
      end
    rescue => e
      flash[:error] = "Failed to thaw file: #{e.message}"
    end
    
    redirect_back fallback_location: files_path
  end

  private

  def frostfs_path
    ENV['FROSTFS_PATH'] || Rails.root.join('storage', 'frostfs')
  end
end
