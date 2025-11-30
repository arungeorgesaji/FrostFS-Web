class DashboardController < ApplicationController
  def index
    @frostfs_path = ENV['FROSTFS_PATH'] || Rails.root.join('storage', 'frostfs')
  end
end
