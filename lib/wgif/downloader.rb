require 'viddl-rb'
require 'httparty'
require 'wgif/video'
require 'tempfile'

module WGif
  class Downloader

    def self.video_url youtube_url
      ViddlRb.get_urls(youtube_url).first
    end

    def self.get_video clip_url
      clip_data = HTTParty.get clip_url
      temp = Tempfile.new "video"
      begin
        temp.write clip_data
      ensure
        temp.close
      end
      WGif::Video.new "wgif-vid", temp.path
    end

  end
end
