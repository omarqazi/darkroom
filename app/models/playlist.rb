class Playlist < ApplicationRecord
  def self.crawl_aws
    s3 = Aws::S3::Client.new
    continuation_token = nil
    more_to_crawl = true
    
    while more_to_crawl
      objects = s3.list_objects_v2({
        bucket: 'smick-media-output',
        delimiter: '/fileSequence',
        prefix: 'media/',
        continuation_token: continuation_token
      })
    
      objects.contents.each do |obj|
        next unless obj.key =~ /program/
        key_comps = obj.key.split("/")
        key_comps.shift
        key_comps.pop
        key = key_comps.join("/")
        url = "https://www.smick.tv/#{obj.key}"
        poster = url.gsub("program.m3u8","poster.png")
        next if Playlist.where(key: key).count > 0
        next if key.blank?
        playlist = Playlist.new(key: key,playlist_url: url, poster_url: poster)
        playlist.save!
      end
      
    
      more_to_crawl = false unless objects.is_truncated
      continuation_token = objects.next_continuation_token
    end
  end
end
