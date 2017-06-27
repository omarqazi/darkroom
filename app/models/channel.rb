class Channel < ApplicationRecord
  belongs_to :guide_server
  validates_presence_of :identifier, :guide_server_id
  validates_uniqueness_of [:identifier, :guide_server_id]
  
  def stream_url
    server_url = guide_server.url
    stream_path = "/streams/#{identifier}.m3u8"
    final_url = URI.join server_url, stream_path
  end
end
