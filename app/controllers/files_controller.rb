class FilesController < ApplicationController
  def index
    @frostfs_path = ENV['FROSTFS_PATH'] || Rails.root.join('storage', 'frostfs')
    
    FileUtils.mkdir_p(@frostfs_path)
    
    begin
      @fs = FrostFS::Filesystem.new(@frostfs_path.to_s)

      create_sample_files_if_empty(@fs) 

      @file_count = @fs.total_file_count
      @stats = @fs.state_stats
    rescue => e
      @error = e.message
    end
  end

  def list
    @frostfs_path = ENV['FROSTFS_PATH'] || Rails.root.join('storage', 'frostfs')
    
    begin
      @fs = FrostFS::Filesystem.new(@frostfs_path.to_s)
      
      @files = []
      
      Dir.glob(File.join(@frostfs_path, '**', '*')).each do |full_path|
        next if File.directory?(full_path)
        next if full_path.include?('.frostfs') 
        
        relative_path = full_path.sub(@frostfs_path.to_s + '/', '')
        
        begin
          info = @fs.file_info(relative_path)
          @files << {
            path: relative_path,
            name: File.basename(relative_path),
            state: info[:state],
            size: info[:size],
            fragmentation: @fs.fragmentation_level(relative_path),
            last_accessed: info[:last_accessed],
            access_count: info[:access_count],
            exists: true
          }
        rescue => e
          file_stat = File.stat(full_path)
          @files << {
            path: relative_path,
            name: File.basename(relative_path),
            state: :active,
            size: file_stat.size,
            fragmentation: 0,
            last_accessed: Time.at(file_stat.mtime),
            access_count: 0,
            exists: false
          }
        end
      end
      
      @files.sort_by! { |f| -f[:last_accessed].to_i }
      
    rescue => e
      @error = e.message
    end
  end

  def upload
    if request.post?
      uploaded_file = params[:file]
      
      if uploaded_file
        begin
          fs = FrostFS::Filesystem.new(frostfs_path)
          filename = uploaded_file.original_filename
          content = uploaded_file.read
          
          result = fs.write_file(filename, content)
          
          if result[:success]
            flash[:success] = "File uploaded successfully: #{filename}"
          else
            flash[:error] = "Failed to upload file: #{result[:error]}"
          end
        rescue => e
          flash[:error] = "Upload error: #{e.message}"
        end
      else
        flash[:error] = "Please select a file to upload"
      end
      
      redirect_to files_list_path
    end
  end

  private 

  def frostfs_path
    ENV['FROSTFS_PATH'] || Rails.root.join('storage', 'frostfs')
  end

  def create_sample_files_if_empty(fs)
    return if fs.total_file_count > 0
    
    sample_files = {
      'welcome.txt' => 'Welcome to FrostFS! This is an active file.',
      'chilled_document.md' => '# Chilled Document\nThis file will become chilled soon.',
      'frozen_data.csv' => 'id,name,value\n1,example,42\n2,test,100',
      'old_archive.zip' => 'This is a simulated archive file that should be frozen.',
      'recent_log.log' => '[INFO] Application started\n[DEBUG] Sample log entry'
    }
    
    sample_files.each do |filename, content|
      fs.write_file(filename, content)
    end
    
    fs.state_manager.force_state('chilled_document.md', :chilled, 'demo')
    fs.state_manager.force_state('frozen_data.csv', :frozen, 'demo') 
    fs.state_manager.force_state('old_archive.zip', :deep_frozen, 'demo')
  end
end
