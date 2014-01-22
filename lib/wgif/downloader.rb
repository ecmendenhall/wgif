require 'viddl-rb'
require 'typhoeus'
require 'ruby-progressbar'
require 'wgif/video'
require 'uri'
require 'cgi'

module WGif
  class Downloader

    def self.video_url youtube_url
      ViddlRb.get_urls(youtube_url).first
    end

    def self.video_id youtube_url
      uri = URI(youtube_url)
      params = CGI.parse(uri.query)
      params['v'].first
    end

    def self.get_video youtube_url
      id = video_id youtube_url
      if cached? id
        return cached_clip id
      else
        temp = load_clip(id, youtube_url)
        WGif::Video.new(id, temp.path)
      end
    end

    private

    def self.cached? id
      File.exist? "/tmp/wgif/#{id}"
    end

    def self.cached_clip id
      WGif::Video.new(id, "/tmp/wgif/#{id}")
    end

    def self.request_clip youtube_url, output_file
      clip_url = self.video_url youtube_url
      request = Typhoeus::Request.new clip_url
      size = nil
      progress_bar = ProgressBar.create(format: '%e %B %p%% %t',
                                        smoothing: 0.8,
                                        total: size)

      request.on_headers do |response|
        size = response.headers['Content-Length'].to_i
        progress_bar.total = size
      end

      request.on_body do |chunk|
          output_file.write(chunk)
          progress_bar.progress += chunk.size
      end

      request.run
    end

    def self.load_clip id, youtube_url
      FileUtils.mkdir_p "/tmp/wgif"
      temp = File.open("/tmp/wgif/#{id}", 'wb')
      begin
        clip = request_clip(youtube_url, temp)
        raise WGif::VideoNotFoundException unless clip.response_code == 200
        clip
      ensure
        temp.close
      end
      temp
    end

  end
end
