class FileActivity
  def self.recent_activities(fs, limit = 10)
    activities = []
    
    fs.metadata_manager.all_files.each do |file_path|
      metadata = fs.metadata_manager.get(file_path)
      
      if metadata.state_history.size > 1
        last_change = metadata.state_history.last
        activities << {
          time: Time.at(last_change['timestamp']),
          message: "#{file_path} changed to #{last_change['state']}",
          type: 'state_change'
        }
      end
      
      if metadata.access_count > 0 && metadata.last_accessed > Time.now.to_i - 3600
        activities << {
          time: Time.at(metadata.last_accessed),
          message: "#{file_path} was accessed",
          type: 'access'
        }
      end
    end
    
    activities.sort_by { |a| -a[:time].to_i }.first(limit)
  end
end
