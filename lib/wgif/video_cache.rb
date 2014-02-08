module WGif
  class VideoCache

    def initialize
      @cache = {}
    end

    def get(video_id)
      path = "/tmp/wgif/#{video_id}"
      if Pathname.new(path).exist?
        WGif::Video.new(video_id, path)
      end
    end

  end
end
