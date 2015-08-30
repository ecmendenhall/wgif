require 'securerandom'
require 'wgif/downloader'

module WGif
  class Converter

    def initialize(args)
      @url = args[:url]
      @trim_from = args[:trim_from]
      @duration = args[:duration]
      @frames = args[:frames]
    end

    def video_to_frames
      clip = video.trim(trim_from, duration)
      clip.to_frames(frames: frames)
    end

    private

    attr_reader :url, :trim_from, :duration, :frames

    def video
      @video ||= youtube_url? ? Downloader.new.get_video(url) : Video.new(SecureRandom.uuid, url)
    end

    def youtube_url?
      uri = URI.parse(url)
      uri && uri.host && uri.host.match(/(www\.)?youtube.com/)
    end

  end
end
