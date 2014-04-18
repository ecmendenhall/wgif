require 'pathname'

module WGif
  class VideoCache

    def initialize
      @cache = {}
    end

    def get(video_id)
      path = "/tmp/wgif/#{video_id}"
      WGif::Video.new(video_id, path) if Pathname.new(path).exist?
    end
  end
end
