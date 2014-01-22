require 'streamio-ffmpeg'
require 'fileutils'

module WGif
  class Video
    attr_accessor :name, :clip

    def initialize name, filepath
      @name = name
      @clip = FFMPEG::Movie.new(filepath)
    end

    def trim start_timestamp, end_timestamp
      duration = time_offset start_timestamp, end_timestamp
      options = {
        audio_codec: "copy",
        video_codec: "copy",
        custom: "-ss #{start_timestamp} -t #{duration}"
      }
      trimmed = @clip.transcode("/tmp/wgif/#{@name}-clip.mp4", options)
      WGif::Video.new "#{@name}-clip", "/tmp/wgif/#{@name}-clip.mp4"
    end

    def to_frames(options={})
      make_frame_dir
      if options[:frames]
        framerate = options[:frames] / @clip.duration
      else
        framerate = 24
      end
      begin
        @clip.transcode("/tmp/wgif/frames/\%2d.png", "-vf fps=#{framerate}")
      rescue FFMPEG::Error => error
        raise error unless error.message.include? "no output file created"
      end
      open_frame_dir
    end

    private

    def make_frame_dir
      FileUtils.rm Dir.glob("/tmp/wgif/frames/*.png")
      FileUtils.mkdir_p "/tmp/wgif/frames"
    end

    def open_frame_dir
      Dir.glob("/tmp/wgif/frames/*.png")
    end

    def time_offset start_timestamp, end_timestamp
      start_values = time_values(start_timestamp)
      end_values   = time_values(end_timestamp)
      offset = end_values.zip(start_values).map do |end_val, start_val|
        end_val - start_val
      end
      values_to_stamp offset
    end

    def time_values timestamp
      timestamp.split(':').map(&:to_i)
    end

    def values_to_stamp values
      values.map {|v| format "%02d", v }.join(':')
    end

  end
end
