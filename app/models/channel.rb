require 'net/http'

class Channel < ApplicationRecord
  belongs_to :guide_server
  validates_presence_of :identifier, :guide_server_id
  
  def stream_url(run_mode = :load)
    server_url = guide_server.url
    stream_path = "/streams/#{run_mode.to_s}/#{identifier}.m3u8"
    final_url = URI.join server_url, stream_path
  end
  
  def update_instruction!
    req = Net::HTTP::Get.new stream_url(:instruction)
    res = send_http_request req
    body = res.body
    inx = URI.unescape(body.strip)
    self.instruction = inx
    save! if changed?
  end
  
  def run_instruction!
    req = Net::HTTP::Put.new stream_url
    req.body = instruction
    send_http_request req
  end
  
  def queue_instruction
    req = Net::HTTP::Post.new stream_url
    req.body = instruction
    send_http_request req
  end
  
  def restart_channel!
    req = Net::HTTP::Patch.new stream_url
    send_http_request req
  end
  
  private
  def send_http_request(req)
    uri = stream_url
    ssl = uri.scheme == 'https'
    
    res = Net::HTTP.start(uri.hostname,uri.port,use_ssl: ssl) do |http|
      http.request(req)
    end
  end
end
