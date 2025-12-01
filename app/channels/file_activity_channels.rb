class FileActivityChannel < ApplicationCable::Channel
  def subscribed
    stream_from "file_activity"
  end
end
